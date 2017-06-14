class AddUserIdToCommercial < ActiveRecord::Migration[5.0]
  def change
    add_column :commercials, :user_id, :integer
  end
end
