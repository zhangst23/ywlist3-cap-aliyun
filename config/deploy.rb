# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'ywlist_cap'
set :repo_url, 'git@github.com:zhangst23/ywlist3-cap-aliyun.git'
set :branch, "cap"
set :deploy_user, 'deployer'

set :scm, :git

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# how many old releases do we want to keep, not much
set :keep_releases, 5

# files we want symlinking to specific entries in shared
set :linked_files, %w{config/database.yml config/application.yml config/secrets.yml}

# dirs we want symlinking to shared
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :unicorn_config_path, -> { File.join(current_path, "config", "unicorn.rb") }

set :rbenv_map_bins, %w{rake gem bundle ruby rails sidekiq sidekiqctl}




after 'deploy:publishing', 'deploy:restart'
namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  task :restart do
    invoke 'unicorn:restart'
  end

end