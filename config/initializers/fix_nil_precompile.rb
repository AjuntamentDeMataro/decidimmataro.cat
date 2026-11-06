# Elimina cualquier entrada nil o tipo inválido en assets.precompile
Rails.application.config.assets.precompile = Rails.application.config.assets.precompile.compact.select do |entry|
  entry.is_a?(String) || entry.is_a?(Regexp) || entry.respond_to?(:call)
end
