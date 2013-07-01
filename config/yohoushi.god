# https://gist.github.com/nragaz/472092
RAILS_ROOT    = ENV['RAILS_ROOT'] = File.expand_path('../..', __FILE__)

%w(unicorn serverengine).each do |config|
  God.load "#{RAILS_ROOT}/config/#{config}.god"
end
