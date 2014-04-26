require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    50.times do |n|
      place =Faker::Address.city
      location = Faker::Address.street_name
      time = 1900 + rand(100)
      date = 1900 + rand(111)
      description = Faker::Lorem.sentence(3, true)

      Place.create!(:place => place,
                    :location => location,
                    :time => time,
                    :date => date,
                    :description => description)




      # name  = Faker::Company.name
      # year = 1900+rand(111)
      # rating = 1+rand(10)
      # watched = (1 == rand(2) ? true : false)
      # imdb_id = rand(1000000)
    end
  end
end