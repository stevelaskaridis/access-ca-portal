ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
require 'simplecov-cobertura'
SimpleCov.formatters = [
  SimpleCov::Formatter::CoberturaFormatter,
]
SimpleCov.start
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
