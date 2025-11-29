source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0"
gem "pg", "~> 1.6"
gem "puma", "~> 7.0"
gem "importmap-rails"
gem "sprockets-rails"

# chore
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "mutex_m"
gem "bootsnap", require: false

# turbo
gem "stimulus-rails"
gem "turbo-rails"

# frontend
gem "tailwindcss-rails", "~> 2.0"

# database / models
gem "data_migrate"
gem "discard", "~> 1.4"
gem "ffaker", "~> 2.25"

# serializer
gem "oj"
gem "pagy", "~> 43.0"
gem "panko_serializer"

# dry
gem "dry-monads"

# geo
gem "activerecord-postgis-adapter", "~> 11.0"
gem "rgeo", "~> 3.0"

# web
gem "faraday"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv"
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 7.0.0"

  # lint
  gem "standard"
  gem "standard-rails"
end

group :development do
  gem "web-console"

  gem "bullet"
  gem "memory_profiler"
  gem "rack-mini-profiler"
  gem "stackprof"

  gem "brakeman", require: false
  gem "bundler-audit"
  gem "fasterer", "~> 0.11.0"
  gem "rails_best_practices"
  gem "rubycritic", require: false
  gem "strong_migrations"
end

group :test do
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
end
