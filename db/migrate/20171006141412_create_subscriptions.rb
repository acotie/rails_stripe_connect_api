class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id               
      t.integer :amount,                 null: false
      t.string  :stripe_subscription_id, null: false
      t.string  :stripe_plan_id         
      t.string  :interval
      t.integer :interval_count
      t.string  :stripe_status

      t.timestamps
    end
  end
end
