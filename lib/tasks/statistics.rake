# frozen_string_literal: true

namespace :statistics do
  desc 'Get statistics of participatory budgets'
  task :budgets, [:id] => :environment do |_task, args|
    if args[:id]
      file = File.open("decidim_budgets_#{args[:id]}_statistics.csv", 'w')
      file << "city,gender,age,project\n"
      Decidim::Budgets::Project.where(decidim_component_id: args[:id]).each do |project|
        Decidim::Authorization.where(
          name: 'census_authorization_handler',
          decidim_user_id: project.orders.pluck(:decidim_user_id)
        ).pluck(:metadata).each do |user|
          file << "#{user['scope']['ca']},#{user['gender']},#{date_to_years user['date_of_birth']},#{project.title['ca']}\n"
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
    file << "city,gender,age\n"
    Decidim::Authorization.where(
      name: 'census_authorization_handler'
    ).pluck(:metadata).each do |user|
      file << "#{user['scope']['es']},#{user['gender']},#{date_to_years user['date_of_birth']}\n"
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
