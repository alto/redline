
default_run_options[:pty] = true

set :application, "redline"
set :repository,  "git@github.com:alto/redline.git"
set :branch,      "origin/master"

set :deploy_to, "/home/alto/apps/#{application}"

set :scm, :git
set :user, "alto"

# ssh_options[:keys] = [ENV['HOME'] + "/.ssh/id_dsa", ENV['HOME'] + "/.ssh/id_rsa"]

role :app, "redline.42towels.com"
role :web, "redline.42towels.com"
role :db,  "redline.42towels.com", :primary => true

after 'deploy:update_code', :set_symlinks
desc "Setting symlinks for everything"
task :set_symlinks do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -s #{shared_path}/data #{release_path}/public/data"
  run "cat #{shared_path}/config/mail.rb >>#{release_path}/config/environments/production.rb"
end
