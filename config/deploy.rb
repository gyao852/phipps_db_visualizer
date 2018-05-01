require 'bundler/capistrano'

server 'dataensemble.net' :web, :app, :db, primary: true #139.59.187.53,
set :application, "phipps_db_visualizer"
set :user, 'phipps'
set :group, 'admin' # Should this be admin?
set :deploy_to, "/var/www/phipps_application/phipps_db_visualizer/"

set :scm, 'git'
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :repository,  "git@github.com:gyao852/phipps_db_visualizer.git"
set :branch, 'master'

set :user_sudo, false

# whenever configuration (for cron jobs)
# require 'whenever/capistrano'
# set :whenever_command, 'bundle exec whenever'

# share public/uploads
set :shared_children, shared_children + %w{public/uploads}

# allow password prompt
default_run_options[:pty] = true

# turn on key forwarding
ssh_options[:forward_agent] = true

# keep only the last 5 releases
after 'deploy', 'deploy:cleanup'
after 'deploy:restart', 'deploy:cleanup'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "#{try_sudo} redis-server" # Should i add these
    #run "#{try_sudo} sidekick -c 1"
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  #task :symlink_shared do
    #run "ln -s /home/cmuis/apps/cmuis/shared/settings.yml /home/cmuis/apps/cmuis/releases/#{release_name}/config/"
  #end
  # Do i need this if I have secrets.yml
end

#before "deploy:assets:precompile", "deploy:symlink_shared"
