# Load the Rails application.
require File.expand_path('../application', __FILE__)

require 'yohoushi/logger'
Rails.logger = Yohoushi.logger(:config => File.expand_path('../application.yml', __FILE__))

# Initialize the Rails application.
Yohoushi::Application.initialize!
