module UsersHelper

  def album_title_picture(album)
    # dummy implementation:
    # show first picture of the album

    if album.pictures.count > 0
      str = image_tag pictures_thumb_dir +
              "#{album.user.login}/#{album.pictures.first.filename}",
              :alt => 'Album: ' + h(album.name)
    else
      str = image_tag('empty.png', :alt => 'This album is still empty.')
    end

    return str
  end

end