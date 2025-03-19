require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }

  # Avoid using the broadcast method
  config.logger = ActiveSupport::Logger.new($stdout)
  config.logger.formatter = Sidekiq::Logger::Formatters::Pretty.new
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end