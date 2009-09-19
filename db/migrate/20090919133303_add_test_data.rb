class AddTestData < ActiveRecord::Migration
  def self.up
    Picture.delete_all

    Picture.create(
      :name => 'jolie image',
      :filename => 'image.png',
      :user_id => 1,
      :album_id => 1
    )

    Picture.create(
      :name => 'photo herbe',
      :filename => 'herbe.jpg',
      :user_id => 1,
      :album_id => 1
    )

    Picture.create(
      :name => 'fake',
      :filename => 'fake.jpg',
      :user_id => 1,
      :album_id => 1
    )

  end

  def self.down
    Picture.delete_all
  end
end

