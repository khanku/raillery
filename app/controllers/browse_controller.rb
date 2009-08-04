class BrowseController < ApplicationController

  def index
    @pictures = Picture.find(:all,
                             :order => "created_at DESC",
                             :limit => get_setting('pictures_per_page'))
    @pictures_in_a_row = get_setting('pictures_per_page')
  end

end
