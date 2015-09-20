OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    '63913591787-ltlir93upfhs86ct0p3psmder3ob2t4d.apps.googleusercontent.com',
    'mAbOjmLvnBIifyZTxr0bKPu4'
end
