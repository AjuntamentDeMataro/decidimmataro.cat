# frozen_string_literal: true

namespace :statistics do
  desc 'Get statistics of participatory budgets'
  task :budgets, [:id] => :environment do |_task, args|
    if args[:id]
      file = File.open("decidim_budgets_#{args[:id]}_statistics.csv", 'w')
      file << "city,gender,age,id,username,project\n"
      Decidim::Budgets::Project.where(decidim_component_id: args[:id]).each do |project|
        Decidim::Authorization.where(
          name: 'census_authorization_handler',
          decidim_user_id: project.orders.pluck(:decidim_user_id)
        ).each do |data|
          file << "#{data.metadata['scope']['ca']},#{data.metadata['gender']},#{date_to_years data.metadata['date_of_birth']},#{data.user.id},#{data.user.nickname},#{project.title['ca']}\n"
        end
      end
      puts "Output file: #{file.path}"
      file.close
    else
      puts 'Please define the component id with rake stadistics:budgets[id]'
    end
  end

  desc 'Get general decidim statistics'
  task general: :environment do
    file = File.open('decidim_general_statistics.csv', 'w')
    file << "city,gender,age,user_id,username\n"
    Decidim::Authorization.where(
      name: 'census_authorization_handler'
    ).each do |data|
      file << "#{data.metadata['scope']['es']},#{data.metadata['gender']},#{date_to_years data.metadata['date_of_birth']},#{data.user.id},#{data.user.nickname}\n"
    end
    puts "Output file: #{file.path}"
    file.close
  end
end

def date_to_years(date)
  if date
    current_date = Date.today
    age = current_date.year - date.to_date.year
    age -= 1 if current_date.yday < date.to_date.yday
    age
  else
    'not provided'
  end
end
