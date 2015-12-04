# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



Stock.create!([
  {symbol: "AAPL", company: "Apple, Inc."},
  {symbol: "FB", company: "Facebook, Inc."},
  {symbol: "GOOG", company: "Google, Inc."},
  {symbol: "NFLX", company: "Netflix"},
])

yahoo_client = YahooFinance::Client.new
symbols = yahoo_client.symbols_by_market('us', 'nyse')
names = yahoo_client.names_by_market('us', 'nyse')

for stock in 0..symbols.length
  Stock.create!(symbol: symbols[stock],
                company: names[stock])
end

User.create!(name:  "Admin User",
             email: "admin@stockr.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             balance: 10000.00)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               balance: 10000.00)
end
