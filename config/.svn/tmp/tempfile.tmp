set :application, "churchsons.myvnc.com"
set :repository,  "."

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
 set :user, "zach"
 set :deploy_to, "/home/#{user}/mac"
 set :use_sudo, false

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :deploy_via, :copy
set :copy_remote_dir, "/home/#{user}"

role :app, application
role :web, application
role :db,  application, :primary => true

namespace :deploy do
<<<<<<< .mine

   desc "Start mongrel processes"
   task :start, :roles => :app do
      mongrel_ports.each do |port|
         run "#{mongrel_cmd} start -d -p #{port} -e production -c #{current_path} -P ../../shared/log/mongrel.#{port}.pid"
      end
   end

   desc "Stop mongrel processes"
   task :stop, :roles => :app do
      mongrel_ports.each do |port|
         run "#{mongrel_cmd} stop -p #{port} -c #{current_path} -P ../../shared/log/mongrel.#{port}.pid"
      end
   end

   desc "Restart mongrel processes"
   task :restart, :roles => :app do
      stop
      start
   end
   
   # task :symlink, :except => { :no_release => true } do
   #     # run "rm -rf #{release_path}/public/system"
   #     run "ln -nfs #{shared_path}/public/system #{release_path}/public/system"
   #     
   #     run "rm -rf #{release_path}/log"
   #     run "ln -nfs #{shared_path}/log #{release_path}/log"
   #     
   #     # run "rm -rf #{release_path}/public/system" #pids directory?
   #     # run "ln -nfs #{shared_path}/public/system #{release_path}/public/system"
   #     
   #   end

=======
  desc "Restarting Passenger"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{release_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
    
  desc "Symlink shared configs and folders on each release."
    task :symlink_shared do
      # run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      run "ln -nfs #{shared_path}/system #{release_path}/public/system"
    end
  
  
>>>>>>> .r538
end

after 'deploy:update_code', 'deploy:symlink_shared'
