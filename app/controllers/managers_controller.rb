class ManagersController < ApplicationController

  def index
    
  end

  def own
    if logged_in?
      @pictures = self.current_user.pictures
      @pictures_in_a_row = get_setting('pictures_per_page')
    end
  end

end
