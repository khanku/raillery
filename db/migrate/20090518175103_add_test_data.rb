class AddTestData < ActiveRecord::Migration
  def self.up
    Picture.delete_all

    Picture.create(
      :name => 'jolie image',
      :path => 'image.png',
      :thumb_path => 'thumb/image.png',
      :user_id => 1
    )

    Picture.create(
      :name => 'photo herbe',
      :path => 'herbe.jpg',
      :thumb_path => 'thumb/herbe.jpg',
      :user_id => 1
    )

    Picture.create(
      :name => 'fake',
      :path => 'fake.jpg',
      :thumb_path => 'thumb/fake.jpg',
      :user_id => 1
    )

  end

  def self.down
    Picture.delete_all
  end
end

