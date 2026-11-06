namespace :cache do
  desc "Limpia la cache"
  task clear: :environment do
    Rails.cache.clear
    puts "Cache limpiada"
  end
end
