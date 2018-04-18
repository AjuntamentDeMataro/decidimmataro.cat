# frozen_string_literal: true

lock "3.8.0"

set :application, "decidim"
set :repo_url, "https://github.com/AjuntamentDeMataro/decidimmataro.cat"
set :linked_files, fetch(:linked_files, []).push(".rbenv-vars")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/cache", "public/uploads")
set :rbenv_type, :user
set :rbenv_ruby, "2.4.2"
set :rbenv_path, "/home/ruby-data/.rbenv"
set :delayed_job_workers, 1

set :passenger_restart_with_touch, true
