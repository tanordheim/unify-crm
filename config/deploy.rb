require 'bundler/capistrano'
load 'deploy/assets'

set :application, 'unify'

set :repository, 'git@github.com:tanordheim/unify.git'
set :scm, :git
set :branch, 'master'

set :user, 'app'
set :deploy_to, '/data/app/unify'
set :deploy_via, :remote_cache
set :use_sudo, false

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :default_environment, { 'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin/:$PATH" }

role :web, 'appsrv.local'
role :app, 'appsrv.local'
role :db, 'appsrv.local', :primary => true

# Server tasks, they do nothing since we use Unicorn.
namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, :roles => :app, :except => { :no_release => true } do; end
end

# Mongoid tasks. These are not run automatically.
namespace :mongoid do
  task :create_indexes do
    run "cd #{current_path} && RAILS_ENV=production bundle exec rake db:mongoid:create_indexes"
  end
end

# Reload Unicorn after deploying
namespace :unicorn do
  task :reload, :roles => :app, :except => { :no_release => true } do
    run 'sudo /usr/bin/bluepill unify_production restart'
    run 'sudo /usr/bin/bluepill unify_workers restart'
  end
  task :restart do
    run 'sudo /usr/bin/bluepill unify_production stop'
    run 'sudo /usr/bin/bluepill unify_workers stop'
    sleep 10
    run 'sudo /usr/bin/bluepill unify_production start'
    run 'sudo /usr/bin/bluepill unify_workers start'
  end
end
after 'deploy:start', 'unicorn:reload'
after 'deploy:restart', 'unicorn:reload'

# Ensure the sockets directory where Unicorn places its socket file exists
namespace :support do
  task :create_socket_directory do
    run "mkdir -p #{shared_path}/sockets"
  end
end
after 'deploy:update_code', 'support:create_socket_directory'
