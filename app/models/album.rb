class Album < ActiveRecord::Base
  validates_presence_of :name, :user_id
  has_many :tweets
end
