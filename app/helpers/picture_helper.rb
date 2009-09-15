module PictureHelper

  def albums_list(user, picture)
    options_from_collection_for_select(
      Album.find_all_by_user_id(user.id, :order => :name),
      'id', 'name', ( picture.album.id if !picture.nil? )
     )
  end

end
