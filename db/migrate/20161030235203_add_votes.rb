class AddVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :commercial_id
      t.integer :value
      #t.string :email
      t.timestamps
    end
  end
end
