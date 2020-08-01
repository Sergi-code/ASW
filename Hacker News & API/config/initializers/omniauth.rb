OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '884848043108-kshfpasuf25ho7oq5gbtl1o5d8lea788.apps.googleusercontent.com', 'LK84suykBW4bLAJI_yiOP7nm', {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end