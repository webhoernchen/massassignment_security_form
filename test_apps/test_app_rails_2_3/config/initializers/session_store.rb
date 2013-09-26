# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_app_rails_2_3_session',
  :secret      => 'e420a8f74820d6f2843abb4066e86869778233514acec88ab48a19a4860e2a3454dc7875c3be9ee1da5f42f5a8c3d556ca90dfff9273d6754173a1e52dfcf409'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
