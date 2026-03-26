# typed: false

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Chairmansmap
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # PS config.eager_load_paths << Rails.root.join("extras") -> deprecated
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    # config.time_zone = "Central Time (US & Canada)"
    config.active_job.queue_adapter = :sidekiq

    # Change to :null_store to avoid any caching.
    # Config in environment files for different environments
    config.cache_store = :redis_cache_store, {
      url: ENV["REDIS_URL"],
      id: "chairmansmap_cache",

      expires_in: 1.hour,
      connect_timeout: 3,
      read_timeout: 1,
      write_timeout: 1,
      reconnect_attempts: 2,

      compress: true,
      compress_threshold: 1.kilobyte,

      pool: {
        size: ENV.fetch("RAILS_MAX_THREADS", 5).to_i,
        timeout: 5
      },

      error_handler: ->(method:, returning:, exception:) {
        Rails.logger.error "Redis error: #{exception}"
      }
      # check maxmemory-policy
    }
  end
end
