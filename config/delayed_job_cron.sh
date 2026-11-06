#!/bin/bash

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
APP_PATH="/var/www/decidim/current"

if ! [ -s $APP_PATH/tmp/pids/delayed_job.pid ]; then
	  RAILS_ENV=production $APP_PATH/bin/delayed_job start
fi
