# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV['MOCK'] ||= 'on'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'multiforecast-client'
require 'multiforecast/shared_context'
require 'webmock/rspec'
WebMock.allow_net_connect! if ENV['MOCK'] == 'off'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# autodoc
Autodoc.configuration.suppressed_request_header = %w(Host Content-Length Content-Type Accept)
Autodoc.configuration.suppressed_response_header = %w(Content-Length Cache-Control ETag X-Content-Type-Options X-Frame-Options X-Request-Id X-Runtime X-XSS-Protection)

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "default"

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
 
  # Disable monkey-patched old should syntax             
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end                                                    
end

def mfclient
  MultiForecast::Client.new(Settings.multiforecast)
end
