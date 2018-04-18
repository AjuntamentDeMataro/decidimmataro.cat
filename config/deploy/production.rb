# frozen_string_literal: true

server "prod-decidimmataro", roles: %w(app db web worker)
set :branch, "master"
