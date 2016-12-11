class AddVideoMeta < ActiveRecord::Migration[5.0]
  def change
    add_column :commercials, :video_meta, :data_type
  end
end
