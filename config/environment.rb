# Load the Rails application.
require File.expand_path('../application', __FILE__)

require File.expand_path("#{Rails.root}/lib/yohoushi/logger")
log_level = (Rails.env == 'development' ? 'debug' : 'info')
Rails.logger = Yohoushi.logger(out: 'log/application.log', shift_age: 10, level: log_level)

# Initialize the Rails application.
Yohoushi::Application.initialize!
