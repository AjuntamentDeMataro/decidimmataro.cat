Doorkeeper.configure do
  # This block will be run once when your app is initialized.
  orm :active_record # or :mongoid or :redis
  resource_owner_authenticator do
    current_user || warden.authenticate!(:scope => :user)
  end
end
