class AddAlbumIdToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :album_id, :integer, :default => 1
  end

  def self.down
    remove_column :pictures, :album_id
  end
end
