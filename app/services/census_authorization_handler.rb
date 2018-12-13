# frozen_string_literal: true

# Checks the authorization against the census for Barcelona.
require 'digest/md5'

# This class performs a check against the official census database in order
# to verify the citizen's residence.
class CensusAuthorizationHandler < Decidim::AuthorizationHandler
  include ActionView::Helpers::SanitizeHelper

  attribute :document_number, String
  validates :document_number, format: { with: /\A[A-z0-9]*\z/ }, presence: true

  attribute :date_of_birth, Date
  validates :date_of_birth,
            format: { with: /\A\d{4}\-\d{2}\-\d{2}\z/ },
            presence: true

  attribute :scope_id, Integer
  validates :scope_id, presence: true

  attribute :gender, String
  validates :gender, inclusion: { in: %w[male female] }, presence: true

  validate :registered_in_town

  def metadata
    super.merge(scope: scope.name,
                gender: gender,
                date_of_birth: sanitized_date_of_birth)
  end

  def scope
    Decidim::Scope.find(scope_id)
  end

  def census_document_types
    %i[dni nie passport].map do |type|
      [
        I18n.t(
          type,
          scope: 'decidim.census_authorization_handler.document_types'
        ),
        type
      ]
    end
  end

  def unique_id
    Digest::MD5.hexdigest(
      "#{document_number}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  private

  def sanitized_date_of_birth
    @sanitized_date_of_birth ||= date_of_birth&.strftime('%d/%m/%Y')
  end

  def registered_in_town
    return nil if response.blank?
    errors.add(:base, 'No empadronat') unless response == 'OK'
  end

  def response
    return nil if document_number.blank?
    return @response if defined?(@response)
    response ||= Faraday.new(
      url: Rails.application.secrets.census_url
    ).get do |request|
      request.url('', nifnie: document_number)
      request.url('', datanaix: sanitized_date_of_birth)
    end
    @response ||= response.body.strip
  end
end
