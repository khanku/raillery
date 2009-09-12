class Picture < ActiveRecord::Base
  belongs_to :user
  has_many :tweets;

  validates_presence_of   :name, :filename, :user_id
  validates_uniqueness_of :filename

end
