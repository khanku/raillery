class Tweet < ActiveRecord::Base
  belongs_to :picture
  belongs_to :user

  validates_presence_of :user_id, :picture_id
  validates_presence_of :message => 'You must write something'
end
