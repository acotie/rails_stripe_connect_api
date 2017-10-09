class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      t.integer :user_id
      t.string :stripe_charge_id
      t.integer :amount
      t.string :currency

      t.timestamps
    end
  end
end
