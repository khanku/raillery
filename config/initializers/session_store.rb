# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_raillery_session',
  :secret      => '3ab357f7a7fb016baaa616bd02dda2bd1efbe9b25f47e9f34d360b3e202eca78f514abdb1a371f1938232ed8cf1a028f9d705f3f7e0a8dfdc5d30a09e04f45b1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
