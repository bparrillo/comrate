class AddDescriptionToCommercials < ActiveRecord::Migration[5.0]
  def change
    add_column :commercials, :description, :text
  end
end
