# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Stock.create!([
  {id: 1, symbol: "AAPL", company: "Apple Inc."},
  {id: 2, symbol: "FB", company: "Facebook, Inc."},
  {id: 3, symbol: "TWTR", company: "Twitter, Inc."},
  {id: 4, symbol: "GOOG", company: "Alphabet Inc."},
  {id: 5, symbol: "NFLX", company: "Netflix, Inc."},
])
