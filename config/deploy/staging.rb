# frozen_string_literal: true

server "stag-decidimmataro", roles: %w(app db web worker)
set :branch, "master"

