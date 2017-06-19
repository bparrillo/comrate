class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :com_payments do |t|
      t.string :card_type
      t.string :number
      t.string :expire_month
      t.string :expire_year
      t.string :cvv2
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country_code
      t.integer :commercial_id
      t.timestamps
    end
  end
end
