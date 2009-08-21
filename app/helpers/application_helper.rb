# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_pics_root
    '/pics/'
  end

  def draw_pages_navigation
    str = '<div id="pages-navigation">'

    if @page > 2
      str += link_to '&lt;&lt;', '?page=1'
      str += "\n"
    end
    if @page > 1
      str += link_to '&lt;', "?page=#{@page - 1}"
      str += "\n"
    end

    str += "[#{@page}]"
    str += "\n"

    if true
      str += link_to '&gt;', "?page=#{@page + 1}"
      str += "\n"
    end
    if true
      str += link_to '&gt;&gt;', "?page=99"
      str += "\n"
    end

    str
  end
end
