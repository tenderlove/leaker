# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_leaker_session',
  :secret      => '0500344811e07d95c43b011437b43d9c87a1edcc531606b03eebfca220d03422caf6924e2d3f2722f3e68d8640d5d294da9bffde6d63b63d2f43fbee42887c32'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
