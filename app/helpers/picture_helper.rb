module PictureHelper

  def albums_list(picture)
    options_from_collection_for_select(
      Album.find(:all, :order => :name), 'id', 'name', ( picture.album.id if !picture.nil? )
     )
  end

end
