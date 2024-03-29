Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_EOK_KEY'], ENV['FACEBOOK_EOK_SECRET'],
  scope: 'public_profile', info_fields: 'id,name,link'
end