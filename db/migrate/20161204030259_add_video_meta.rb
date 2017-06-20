class AddVideoMeta < ActiveRecord::Migration[5.0]
  def change
    add_column :commercials, :video_meta, :text
  end
end
