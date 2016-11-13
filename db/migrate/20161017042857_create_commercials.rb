class CreateCommercials < ActiveRecord::Migration[5.0]
  def change
    create_table :commercials do |t|
      t.timestamps
      t.string :title
    end
  end
end
