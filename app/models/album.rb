class Album < ActiveRecord::Base
  belongs_to :user
  has_many :pictures

  validates_presence_of :name, :user_id

  before_destroy :delete_contained_pictures

  def delete_contained_pictures
    for picture in self.pictures
      picture.destroy
    end
  end
end
