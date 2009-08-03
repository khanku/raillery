class AddDefaultSettings < ActiveRecord::Migration
  def self.up
    Setting.delete_all

    Setting.create(
      :key => 'thumb_width',
      :value => '100'
    )

    Setting.create(
      :key => 'public_pictures_directory',
      :value => 'public/pics'
    )

  end

  def self.down
    Setting.delete_all
  end
end

