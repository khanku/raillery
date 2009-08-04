class BrowseController < ApplicationController

  def index
    @pictures = Picture.find(:all,
                             :order => "created_at DESC",
                             :limit => get_setting('pictures_per_page'))
    @pictures_in_a_row = get_setting('pictures_per_page')
  end

  def test
    @pictures = Picture.find(:all, :order => "created_at DESC", :limit => 5)
  end

  def manage
    if logged_in?
      @pictures = Picture.find_all_by_user_id(self.current_user.id, :order => "created_at DESC")
    end
  end
end
