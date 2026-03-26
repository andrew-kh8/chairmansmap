# typed: false

Sidekiq.configure_server do |config|
  config.redis = {url: ENV["SIDEKIQ_REDIS_URL"], id: "Sidekiq-server-PID-#{::Process.pid}"}
end

Sidekiq.configure_client do |config|
  config.redis = {url: ENV["SIDEKIQ_REDIS_URL"], id: "Sidekiq-client-PID-#{::Process.pid}"}
end
