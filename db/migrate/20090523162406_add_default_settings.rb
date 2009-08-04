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

    Setting.create(
      :key => 'pictures_in_a_row',
      :value => '5'
    )

    Setting.create(
      :key => 'pictures_per_page',
      :value => '25'
    )

  end

  def self.down
    Setting.delete_all
  end
end

