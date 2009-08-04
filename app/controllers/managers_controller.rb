class ManagersController < ApplicationController

  def index
    
  end

  def own
    if logged_in?
      @pictures = Picture.find_all_by_user_id(self.current_user.id, :order => "created_at DESC")
    end
  end

end
