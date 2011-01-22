ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Bundler.require(:default, :test)
require 'capybara/rails'

require 'shoulda'
require 'coulda'
require 'factory_girl'
require 'factories'

Coulda.default_testcase_class = ActionController::IntegrationTest

class ActionController::IntegrationTest
  extend Coulda::WebSteps

  include Capybara
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
