set :application, "KarStat"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work

set :repository, "git@github.com:myrlund/KarStat.git"  # Your clone URL

set :scm, "git"
set :scm_verbose, true
set :branch, "master"

set :user, "jonas"  # The server's user for deploys
# set :scm_passphrase, "p@ssw0rd"  # The deploy user's password
set :deploy_via, :remote_cache
set :use_sudo, false
set :deploy_to, "/www/karstat"

role :web, "login.danseku.no"                          # Your HTTP server, Apache/etc
role :app, "login.danseku.no"                          # This may be the same as your `Web` server
role :db,  "login.danseku.no", :primary => true # This is where Rails migrations will run
role :db,  "login.danseku.no"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
