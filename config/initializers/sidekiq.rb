Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://:26111979@redis:6379' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://:26111979@redis:6379' }
end