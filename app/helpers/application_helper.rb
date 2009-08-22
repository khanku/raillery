# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def get_pics_root
    '/pics/'
  end

  def draw_pages_navigation
    str = '<div id="pages-navigation">'

    if (@page > 2)
      str += link_to '&lt;&lt;', '?page=1'
      str += "\n"
    end
    if (@page > 1)
      str += link_to '&lt;', "?page=#{@page - 1}"
      str += "\n"
    end

    last_page = @pictures_count / @pictures_per_page + 1

    if(@page > 1 || last_page > 1)
      str += "[#{@page}]"
      str += "(#{last_page} pages totalizing #{pictures_count} pictures"
      str += "\n"
    end

    if (@page < last_page)
      str += link_to '&gt;', "?page=#{@page + 1}"
      str += "\n"
    end
    if (@page < last_page - 1)
      str += link_to '&gt;&gt;', "?page=#{last_page}"
      str += "\n"
    end

    str
  end

  def show_flash(options={})
    options = {:fade => 2, :display => 5, :highlight => true}.merge(options)
    html = content_tag(:span, flash.collect{ |key,msg| content_tag(:span, msg, :class => key, :attributes => "style = display: none;") }, :id => 'notice')
    html << content_tag(:script, "new Effect.Highlight('notice');") if options[:highlight]
    html << content_tag(:script, "$('notice').appear();")
    html << content_tag(:script, "setTimeout(\"$('notice').fade({duration: #{options[:fade]}});\", #{options[:display]*1000});")
  end

end
