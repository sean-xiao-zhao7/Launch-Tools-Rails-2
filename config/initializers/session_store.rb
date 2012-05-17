# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_LAUNCH-Tools_session',
  :secret      => '37ffab41a0753ea0c960e957c70e00dc9a8803d4430bd341c8be505b4ef0b1e44c5c51349d960b84fecc23c79466dd258a9f30b9a99eec43d43a9bb101315453'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
