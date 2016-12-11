class AddAttachmentVideoToCommercials < ActiveRecord::Migration
  def self.up
    change_table :commercials do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :commercials, :video
  end
end