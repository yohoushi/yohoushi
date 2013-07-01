num_workers = (RAILS_ENV == 'production') ? 4 : 2
 
num_workers.times do |num|
  God.watch do |w|
    w.name = "resque-#{num}"
    w.group = 'resque'
    w.interval = 30.seconds
    w.env = {"QUEUE"=>"*", "RAILS_ENV"=>RAILS_ENV}
 
    # resque:work has a dependency on environment in my Rakefile, so no need to call it first
    w.start = "#{BIN_PATH}/rake -f #{RAILS_ROOT}/Rakefile resque:work"
 
    w.uid = 'rails' # user id
    w.gid = 'rails' # group id
 
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
end
