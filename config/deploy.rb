require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'

load 'deploy/assets'

set :application, "SocialAwards"

set :rails_env, "production"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :keep_releases, 4
set :god_config_file, "#{deploy_to}/current/config/god_config.god"
set :branch, fetch(:branch, 'master')

set :domain, "ubuntu@ec2-46-137-39-248.eu-west-1.compute.amazonaws.com"
ssh_options[:keys] = ["#{ENV['HOME']}/Documents/FalconKey.pem"]
role :web, domain
role :app, domain
role :db,  domain, :primary => true



#set :whenever_environment, defer { stage }
#set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"

set :deploy_to, "/home/ubuntu/#{application}"
set :use_sudo, false

set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

set :faye_config, "#{deploy_to}/current/faye.ru"
set :faye_pid, "#{deploy_to}/shared/pids/faye.pid"

# set :resque_pid, "#{deploy_to}/shared/pids/resque.pid"
# set :resque_log,  "#{deploy_to}/shared/log/resque.log"


set :rvm_ruby_string, '1.9.3@awards'
set :rvm_type, :user

set :scm, :git
set :repository, "git@github.com:SocialDevelopment/SocialPremia.git"
set :deploy_via, :remote_cache

after 'deploy:update_code', 'symlinks:set'
after "deploy:update", "deploy:cleanup"



namespace :symlinks do
  task :set, :roles => :app  do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"

    run "ln -s #{deploy_to}/shared/images/users #{current_release}/public/images/users"
  end
end


#after 'symlinks:set', 'assets:precompile'

#namespace :assets do 
#  task :precompile, :roles => :app  do
#    run "cd #{current_release} && bundle exec rake assets:precompile"
#  end
#end


#  start program = "/usr/bin/env HOME=/home/user 
#RACK_ENV=production PATH=/usr/local/bin:/usr/local/ruby/bin:/usr/bin:/bin:$PATH /bin/sh -l -c 
#'cd /data/APP_NAME/current; nohup bundle exec rake environment resque:work RAILS_ENV=production QUEUE=queue_name VERBOSE=1 PIDFILE=tmp/pids/resque_worker_QUEUE.pid & >> log/resque_worker_QUEUE.log 2>&1'" as uid deploy and gid deploy

#before 'deploy:update_code', 'daemons:stop'
#after 'deploy:finalize_update', 'daemons:start'


#namespace :daemons do
#  task :start, :roles => :app do #TODO role may be other server
#    #cd #{rails_root} && bundle exec thin start -R #{rails_root}/faye.ru -p 9292 -dP #{faye_pid}
#    run "cd #{deploy_to}/current && bundle exec thin start -R #{faye_config} -p 9292 -dP #{faye_pid}"
#    #run "cd #{deploy_to}/current && nohup bundle exec rake environment resque:work RAILS_ENV=#{rails_env} QUEUE='*' VERBOSE=1 PIDFILE=#{resque_pid} & >> #{resque_log} 2>&1"
#  end
#  task :stop do
#     run "if [ -f #{faye_pid} ] && [ -e /proc/$(cat #{faye_pid}) ]; then cd #{deploy_to}/current && bundle exec thin stop -P #{faye_pid}; fi"
#    #run "if [ -f #{resque_pid} ] && [ -e /proc/$(cat #{resque_pid}) ]; then kill -QUIT `cat #{resque_pid}`; fi"
#  end
#end


#before 'faye:start', 'daemons:stop'
#after 'faye:start', 'daemons:start'

#after 'faye:stop', 'daemons:stop'

namespace :faye do
  task :start, :roles => :app do #TODO role may be other server
    run "cd #{deploy_to}/current && bundle exec thin start -R #{faye_config} -p 9292 -dP #{faye_pid}"
  end
  task :stop do
     run "if [ -f #{faye_pid} ] && [ -e /proc/$(cat #{faye_pid}) ]; then cd #{deploy_to}/current && bundle exec thin stop -P #{faye_pid}; fi"
  end
end



#after 'deploy:update_code', 'daemons:copy_to_shared'

#after 'daemons:start', 'redis:fill'


def god_is_running
  !capture("#{god_command} status >/dev/null 2>/dev/null || echo 'not running'").start_with?('not running')
end

def god_command
  "cd #{current_path}; bundle exec god"
end

def terminate_if_runing
  if god_is_running
    run "#{god_command} terminate"
  end
end

def god_start
  environment = { :RAILS_ENV => rails_env, :RAILS_ROOT => current_path }
  run "#{god_command} -c #{god_config_file}", :env => environment
end

def god_exec(command)
  run "#{god_command} #{command}"
end


namespace :unicorn do
  task :start, :roles => :app do
    god_exec "start unicorn"
  end
  task :stop do
    god_exec "stop unicorn"
  end
  task :restart do
    god_exec "restart unicorn"
  end
end


namespace :god do
  desc "Stop god"
  task :stop do
    terminate_if_runing
  end

  desc "Start god"
  task :start do
    god_start
  end
end



# Далее идут правила для перезапуска unicorn. Их стоит просто принять на веру - они работают.
# В случае с Rails 3 приложениями стоит заменять bundle exec unicorn_rails на bundle exec unicorn
namespace :deploy do
  task :restart do
    god_exec "restart unicorn"
  end
  task :start do
    god_exec "start unicorn"
  end
  task :stop do
    god_exec "stop unicorn"
  end
end

namespace :redis do
  task :flush do
    run 'redis-cli FLUSHDB'
  end
  task :fill do
    run "cd #{deploy_to}/current && bundle exec rake load_data_to_redis RAILS_ENV='#{rails_env}'"
  end
  task :flush_and_fill do
    flush
    fill
  end
end


#before "deploy:update", "god:terminate_if_running"
#after "deploy:update", "god:start"

after "migration:reload", "deploy:restart"
namespace :migration do
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "cd #{deploy_to}/current && bundle exec rake db:migrate RAILS_ENV='#{rails_env}'"
  end
end

#require './config/boot'
#require 'airbrake/capistrano'
