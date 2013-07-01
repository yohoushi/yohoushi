# https://gist.github.com/nragaz/472092
PID_DIR       = '/srv/myapp/shared/pids'
RAILS_ENV     = ENV['RAILS_ENV'] = 'production'
RAILS_ROOT    = ENV['RAILS_ROOT'] = '/srv/myapp/current'
BIN_PATH      = "/home/rails/.rvm/gems/ree-1.8.7-2010.02/bin"
 
God.log_file  = "#{RAILS_ROOT}/log/god.log"
God.log_level = :info
 
%w(unicorn resque).each do |config|
  God.load "#{RAILS_ROOT}/config/god/#{config}.god"
end
