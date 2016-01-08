Sidekiq.configure_server do |config|
  config.redis = { url: "#{APP_CONFIG['app_confs']['redis']['url']}/12" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{APP_CONFIG['app_confs']['redis']['url']}/12" }
end
