# Load the Rails application.
require File.expand_path('../application', __FILE__)

require File.expand_path("#{Rails.root}/lib/yohoushi/logger")
Rails.logger = Yohoushi.logger(out: 'log/application.log', shift_age: 3) # shift_age: 0 to stop logrotate

# Initialize the Rails application.
Yohoushi::Application.initialize!
