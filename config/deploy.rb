require "bundler/capistrano"
require "delayed/recipes"

#############################################################
#	Stages
#############################################################

set :default_stage, "production"
set :stages, %w(production)
require 'capistrano/ext/multistage'

#############################################################
#	Application
#############################################################

set :application, "tomtelizer"
set :deploy_to, "/var/www/apps/#{application}"
set :keep_releases, 2
after "deploy:update", "deploy:cleanup"

#############################################################
#	Settings
#############################################################

set :user, "deploy"
set :use_sudo, false
set :rails_env, "production" #added for delayed job

#############################################################
#	Git
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :scm, :git
set :deploy_via, :remote_cache
set :repository,  "git@github.com:athega/tomtelizer-server.git"

#############################################################
# Passenger
#############################################################

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  # Delayed Job
  before "deploy:restart", "delayed_job:stop"
  after  "deploy:restart", "delayed_job:start"

  after "deploy:stop",  "delayed_job:stop"
  after "deploy:start", "delayed_job:start"

  task :restart, :roles => :app, :except => { :no_release => true } do
    db_path = "/var/www/apps/#{application}/shared/production.sqlite3"
    images_path = "/var/www/vhosts/assets.athega.se/jullunch/tomtelizer"

    run "ln -sf #{db_path} /#{File.join(current_path,'db','production.sqlite3')}"

    run "rm -rf /#{File.join(current_path,'public','uploaded_images')}"
    run "ln -sf #{images_path} /var/www/apps/#{application}/current/public/uploaded_images"

    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
