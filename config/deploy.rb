# ========================
# CONFIG
# ========================
set :application, "twitterdinks"
set :scm, :git
set :git_enable_submodules, 1
set :repository, "git@github.com:flippyhead/mytwee.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
set :stage, :production
set :user, "root"
set :use_sudo, false
set :runner, "deploy"
set :deploy_to, "/home/sinatra/#{application}"
set :app_server, :passenger
set :domain, "mytwee.com"

# ========================
# ROLES
# ========================
role :app, domain
role :web, domain
role :db, domain, :primary => true

# ========================
# CUSTOM
# ========================
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  task :stop, :roles => :app do
    # Do nothing.
  end
  
  task :after_update_code  do
    run "chown -R apache #{release_path}"
  end
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

