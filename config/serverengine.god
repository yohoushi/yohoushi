# https://gist.github.com/nragaz/472092
# https://github.com/frsyuki/serverengine
RAILS_ENV     ||= ENV['RAILS_ENV'] ||= 'production'
RAILS_ROOT    ||= ENV['RAILS_ROOT'] = File.expand_path('../..', __FILE__)
PID_DIR       ||= "#{RAILS_ROOT}/log"
BIN_PATH      ||= "#{RAILS_ROOT}/bin"
 
God.watch do |w|
  w.name = "serverengine"
  w.group = "yohoushi"
  w.interval = 30.seconds

  # needs to be run from the rails root
  w.start   = "cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} #{BIN_PATH}/serverengine start -p #{PID_DIR}/serverengine.pid -d"

  # TERM to graceful stop, QUIT to stop
  w.stop = "kill -TERM `cat #{PID_DIR}/serverengine.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{PID_DIR}/serverengine.pid"
 
  # w.uid = 'rails'
  # w.gid = 'rails'
 
  w.behavior(:clean_pid_file)

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end
end
