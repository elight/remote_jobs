# Load the rails application
require File.expand_path('../application', __FILE__)

unless Rails.env == 'production'
  heroku_env = File.join(Rails.root, 'config', 'heroku_env.rb')
  load(heroku_env) if File.exists?(heroku_env)
end

if ENV["ACTIVE_MERCHANT_MODE"]
  ActiveMerchant::Billing::Base.mode = ENV["ACTIVE_MERCHANT_MODE"].to_sym
end

# Initialize the rails application
RemoteJobs::Application.initialize!
