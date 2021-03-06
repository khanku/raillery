class AddDefaultSettings < ActiveRecord::Migration
  def self.up
    Setting.delete_all

    Setting.create(
      :key => 'public_pictures_directory',
      :value => 'public/pics/'
    )

    Setting.create(
      :key => 'thumb_width',
      :value => '100'
    )

    Setting.create(
      :key => 'thumb_path_prefix',
      :value => 'thumb/'
    )

    Setting.create(
      :key => 'pictures_in_a_row',
      :value => '4'
    )

    Setting.create(
      :key => 'pictures_per_page',
      :value => '12'
    )

  end

  def self.down
    Setting.delete_all
  end
end

