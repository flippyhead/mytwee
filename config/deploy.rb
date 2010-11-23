# ========================
# CONFIG
# ========================
set :application, "mytwee"
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
    bundler.bundle_new_release
    run "chown -R apache #{release_path}"
    run "chmod 666 #{release_path}/views/flash.erb"
  end
  
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, '.bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
  
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    run "cd #{release_path} && bundle install vendor --disable-shared-gems --without test development"
  end
  
  task :lock, :roles => :app do
    run "cd #{current_release} && bundle lock;"
  end
  
  task :unlock, :roles => :app do
    run "cd #{current_release} && bundle unlock;"
  end
end
