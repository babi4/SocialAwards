rails_env = ENV['RAILS_ENV'] || 'production'
deploy_dir  = "/home/ubuntu/SocialAwards"
rails_root  =   ENV['RAILS_ROOT'] || "#{deploy_dir}/current"
faye_pid = "#{deploy_dir}/shared/pids/faye.pid"

God.watch do |w|
  w.name = "unicorn"
  w.interval = 30.seconds # default
  w.dir = rails_root
  # unicorn needs to be run from the rails root
  w.start = "cd #{rails_root} && bundle exec unicorn_rails -c #{rails_root}/config/unicorn.rb -E #{rails_env} -D"

  # QUIT gracefully shuts down workers
  w.stop = "kill -QUIT `cat #{rails_root}/tmp/pids/unicorn.pid`"

  # USR2 causes the master to re-create itself and spawn a new worker pool
  w.restart = "kill -USR2 `cat #{rails_root}/tmp/pids/unicorn.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{rails_root}/tmp/pids/unicorn.pid"

#  w.uid = 'superuser'
#  w.gid = 'git'

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = 300.megabytes
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = 50.percent
      c.times = 5
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



unicorn_worker_memory_limit = 200000

Thread.new do
  loop do
    begin
      # unicorn workers
      #
      # ps output line format:
      # 31580 275444 unicorn_rails worker[15] -c current/config/unicorn.rb -E production -D
      # pid ram command

      lines = `ps -e -www -o pid,rss,command | grep '[u]nicorn_rails worker'`.split("\n")
      lines.each do |line|
        parts = line.split(' ')
        if parts[1].to_i > unicorn_worker_memory_limit
          # tell the worker to die after it finishes serving its request
          ::Process.kill('QUIT', parts[0].to_i)
        end
      end
    rescue Object
      # don't die ever once we've tested this
      nil
    end

    sleep 30
  end
end






=begin

num_workers = rails_env == 'production' ? 2 : 1

num_workers.times do |num|


  God.watch do |w|
    w.dir      = "#{rails_root}"
    w.name     = "resque-#{num}"
    w.group    = 'resque'
    w.interval = 30.seconds
    w.pid_file = "#{deploy_dir}/shared/pids/#{w.name}.pid"
    w.env      = {"QUEUE"=>"*", "RAILS_ENV"=>rails_env, 'PIDFILE' => w.pid_file}
    w.start    = "bundle exec rake environment resque:work &"

    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 200.megabytes
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
=end




  
  God.watch do |w|
    w.name = "thin"
    
    w.interval = 30.seconds
    
    
   # w.start = "thin start -C #{file} -o #{number}"
    w.start = "cd #{rails_root} &&  bundle exec thin start -R #{rails_root}/faye.ru -p 9292 -dP #{faye_pid}"
    w.start_grace = 10.seconds
    
    w.stop = "cd #{rails_root} && bundle exec thin stop -R #{rails_root}/faye.ru -p 9292 -dP #{faye_pid}"
    w.stop_grace = 10.seconds
    
    w.restart = "cd #{rails_root} &&  bundle exec thin stop -R #{rails_root}/faye.ru -p 9292 -dP #{faye_pid}"


    w.pid_file = faye_pid
    
    w.behavior(:clean_pid_file)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = [3,5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end

    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minutes
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
      end
    end
  end
  

