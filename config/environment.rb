# Load the Rails application.
require File.expand_path('../application', __FILE__)

require File.expand_path('../../lib/yohoushi/logger', __FILE__)
Rails.logger = Yohoushi.logger(:config => File.expand_path('../application.yml', __FILE__))

# Initialize the Rails application.
Yohoushi::Application.initialize!
