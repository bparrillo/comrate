class AddDescriptionToCommercials < ActiveRecord::Migration[5.0]
  def change
    add_column :commercials, :description, :text
    #add_column :commercials, :created_at,:datetime
    #add_column :commercials, :updated_at, :datetime
  end
end
