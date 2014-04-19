# https://gist.github.com/nragaz/472092
# http://unicorn.bogomips.org/SIGNALS.html
RAILS_ENV     ||= ENV['RAILS_ENV'] ||= 'production'
RAILS_ROOT    ||= ENV['RAILS_ROOT'] = File.expand_path('../..', __FILE__)
PID_DIR       ||= "#{RAILS_ROOT}/log"
BIN_PATH      ||= "#{RAILS_ROOT}/bin"

settings = YAML.load_file("#{ENV['RAILS_ROOT']}/config/application.yml")[ENV['RAILS_ENV']]['unicorn'] || {}

God.watch do |w|
  w.name = "unicorn"
  w.group = "yohoushi"
  w.interval = 30.seconds # default
  
  # unicorn needs to be run from the rails root
  w.start = "cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} #{BIN_PATH}/unicorn -c #{RAILS_ROOT}/config/unicorn.conf -E #{RAILS_ENV} -D"
 
  # QUIT gracefully shuts down workers
  w.stop = "kill -QUIT `cat #{PID_DIR}/unicorn.pid`"
 
  # USR2 causes the master to re-create itself and spawn a new worker pool
  w.restart = "kill -USR2 `cat #{PID_DIR}/unicorn.pid`"
 
  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{PID_DIR}/unicorn.pid"
 
  # w.uid = 'rails'
  # w.gid = 'rails'
 
  w.behavior(:clean_pid_file)
 
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end
 
  # lifecycle
  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end
