# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gem "decidim", git: "https://github.com/decidim/decidim", branch: "0.19-stable"
gem "decidim-consultations"
# gem "decidim-initiatives"

gem "puma", "~> 3.12"
gem "uglifier", "~> 4.1"

gem "faker", "~> 1.8"

gem "airbrake", "~> 5.0"
gem "daemons", "~> 1.2.6"
gem "delayed_job_active_record", "~> 4.1.2"
gem "virtus-multiparams"

group :development, :test do
  gem "byebug", "~> 10.0", platform: :mri
  gem "decidim-dev"
end

group :development do
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"

  # deploy
  gem "capistrano", "3.8.0", require: false
  gem "capistrano-bundler", "~> 1.2", require: false
  gem "capistrano-passenger"
  gem "capistrano-rails", "1.1.8", require: false
  gem "capistrano-rbenv"
  gem "capistrano3-delayed-job", "~> 1.0"
end
