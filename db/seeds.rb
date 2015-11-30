# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User_Owns.create!([
  {email: 'matthew@email.com', symbol: "AAPL"},
  {email: 'matthew@email.com', symbol: "FB"},
  {email: 'matthew@email.com', symbol: "TWTR"},
  {email: 'matthew@email.com', symbol: "GOOG",},
  {email: 'matthew@email.com', symbol: "NFLX",},
])

User.create!(name:  "Admin User",
             email: "admin@stockr.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
