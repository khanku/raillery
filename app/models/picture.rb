class Picture < ActiveRecord::Base
  belongs_to :user
  belongs_to :album
  has_many :tweets

  validates_presence_of   :name, :filename, :user_id
  validates_uniqueness_of :filename

  before_destroy :delete_tweets
  before_destroy :delete_files

  include ApplicationEnvironment  # shared functions

  def delete_tweets
    for tweet in self.tweets
      tweet.destroy
    end
  end

  def delete_files
    FileUtils.rm_f(path_to_thumbnail(self.filename))
    FileUtils.rm_f(path_to_picture(self.filename))
  end
end
