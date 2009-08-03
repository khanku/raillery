class BrowseController < ApplicationController
  def index
    @pictures = Picture.find(:all, :order => "created_at DESC")
  end

  def manage
    if logged_in?
      @pictures = Picture.find_all_by_user_id(self.current_user.id, :order => "created_at DESC")
    end
  end
end
