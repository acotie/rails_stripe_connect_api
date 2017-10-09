# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "stripe"
Stripe.api_key = ENV["STRIPE_API_KEY"]

# Stripe
if !Stripe::Plan.list
  Stripe::Plan.create( :amount => 5000, :interval => 'month', :name => 'monthly gold', :currency => 'usd', :id => 'gold')
  Stripe::Plan.create( :amount => 2500, :interval => 'month', :name => 'monthly silver', :currency => 'usd', :id => 'silver')
  Stripe::Plan.create( :amount => 700, :interval => 'month', :name => 'monthly bronze', :currency => 'usd', :id => 'bronze')
end

User.create!(:email => 'test1@foo.com', :password => '12345678', :password_confirmation => '12345678')
User.create!(:email => 'test2@foo.com', :password => '12345678', :password_confirmation => '12345678')
User.create!(:email => 'test3@foo.com', :password => '12345678', :password_confirmation => '12345678')
