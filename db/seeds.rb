# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

s1 = Stock.create name:"Microsoft Corporation", symbol:"MSFT"
s2 = Stock.create name:"Apple Inc.", symbol:"AAPL"
s3 = Stock.create name:"Facebook Inc.", symbol:"FB"
s4 = Stock.create name:"Tesla Inc", symbol:"TSLA"
s5 = Stock.create name:"AT&T Inc", symbol:"T"