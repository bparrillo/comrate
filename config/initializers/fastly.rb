FastlyRails.configure do |config|
  config.api_key = !Rails.env.production? ? 'fake' : ENV.fetch("FASTLY_API_KEY")
  thirty_days_in_seconds = 2592000
  config.max_age = thirty_days_in_seconds
  config.service_id = !Rails.env.production? ? 'fake' : ENV.fetch("FASTLY_SERVICE_ID")
end