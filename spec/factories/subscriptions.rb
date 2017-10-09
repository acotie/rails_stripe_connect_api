FactoryGirl.define do
  factory :subscription do
    user_id 1
    amount "9.99"
    stripe_customer_id "MyString"
    stripe_subscription_id "MyString"
  end
end
