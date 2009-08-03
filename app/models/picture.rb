class Picture < ActiveRecord::Base
  belongs_to :user
  has_many :tweets;

  validates_presence_of   :name, :path, :thumb_path, :user_id
  validates_uniqueness_of :path, :thumb_path
end
