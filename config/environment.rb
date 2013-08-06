# Load the Rails application.
require File.expand_path('../application', __FILE__)

require File.expand_path("#{Rails.root}/lib/yohoushi/logger")
Rails.logger = Yohoushi.logger(out: 'log/application.log', shift_age: 3) # shift_age: 0 to stop logrotate

# Hack: Load production.rb as default if #{ENV['RAILS_ENV']}.rb does not exist
unless %w[production development test].include?(ENV['RAILS_ENV'])
  unless File.exists?(File.expand_path("#{Rails.root}/config/environments/#{ENV['RAILS_ENV']}.rb"))
    require File.expand_path("#{Rails.root}/config/environments/production")
  end
end
# Initialize the Rails application.
Yohoushi::Application.initialize!
