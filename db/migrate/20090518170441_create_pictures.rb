class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string  :name
      t.string  :path
      t.string  :thumb_path
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
