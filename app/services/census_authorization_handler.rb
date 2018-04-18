# frozen_string_literal: true
# Checks the authorization against the census for Barcelona.
require "digest/md5"

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  attribute :document_number, String
  validates :document_number, format: { with: /\A[A-z0-9]*\z/ }, presence: true

  attribute :date_of_birth, String
  validates :date_of_birth, format: { with: /\A\d{2}\/\d{2}\/\d{4}\z/ }, presence: true

  attribute :scope_id, Integer
  validates :scope_id, presence: true

  attribute :gender, String
  validates :gender, inclusion: { in: %w(male female) }, presence: true

  validate :registered_in_town

  def self.from_params(params, additional_params = {})
    instance = super(params, additional_params)

    params_hash = hash_from(params)

    if params_hash["date_of_birth(1i)"]
      date = Date.civil(
        params["date_of_birth(1i)"].to_i,
        params["date_of_birth(2i)"].to_i,
        params["date_of_birth(3i)"].to_i
      )

      instance.date_of_birth = date
    end

    instance
  end

  # If you need to store any of the defined attributes in the authorization you
  # can do it here.
  #
  # You must return a Hash that will be serialized to the authorization when
  # it's created, and available though authorization.metadata
  def metadata
    super.merge({
      scope: scope.name,
      gender: gender
    })
  end

  def scope
    Decidim::Scope.find(scope_id)
  end

  def census_document_types
    %i(dni nie passport).map do |type|
      [I18n.t(type, scope: "decidim.census_authorization_handler.document_types"), type]
    end
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def registered_in_town
    return nil if response.blank?
    errors.add(:base, 'No empadronat') unless response == "OK"
  end

  def response
    return nil if document_number.blank?
    return @response if defined?(@response)

    response ||= Faraday.new(:url => Rails.application.secrets.census_url).get do |request|
      request.url('', nifnie: document_number)
      request.url('', datanaix: date_of_birth)
    end

    @response ||= response.body.strip
  end

end
