ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'mocha/minitest'
require 'vcr'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  VCR.configure do |config|
    config.cassette_library_dir = "test/vcr/vcr_cassettes"
    config.hook_into :webmock
    # Avoid conflict with Selenium
    config.ignore_localhost = true

    # Allow downloading webdrivers for Selenium
    driver_hosts = Webdrivers::Common.subclasses.map { |driver| URI(driver.base_url).host }
    # Downloading the Firefox driver involves a redirect
    driver_hosts += ["github-releases.githubusercontent.com"]
    config.ignore_hosts(*driver_hosts)
  end
end
