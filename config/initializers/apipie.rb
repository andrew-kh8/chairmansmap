# frozen_string_literal: true

Apipie.configure do |config|
  config.app_name = "Chairman's map"
  config.api_base_url = '/api'
  config.doc_base_url = '/api-docs'
  config.api_controllers_matcher = Rails.root.join('app/controllers/api/**/*.rb').to_s
end
