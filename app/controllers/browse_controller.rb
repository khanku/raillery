class BrowseController < ApplicationController

  def index
    @page = params[:page].to_i ||= 1
    if (@page < 1)
      @page = 1
    end

    pictures_per_page = get_setting('pictures_per_page').to_i
    offset = (@page - 1) * pictures_per_page

    @pictures = Picture.find(:all,
                             :order => "created_at DESC",
                             :limit => pictures_per_page,
                             :offset => offset
                            )
    @pictures_in_a_row = get_setting('pictures_in_a_row')
  end

end
