class AddStripeCustomerIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :stripe_card_id, :string
    add_column :users, :subscribed, :boolean, default: false
    add_column :users, :subscribed_at, :datetime
    add_index :users, :stripe_customer_id
  end
end
