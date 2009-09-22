module PictureStorage
  protected

    def store(file_to_store, picture_name, album_id)

      pic = Picture.create(
        :name => picture_name,
        :filename => file_to_store,
        :user_id => self.current_user.id,
        :album_id => album_id
      )
      pic.save

      if !pic.errors.empty?
        flash[:notice] = get_errors_for(pic)
        return 1
      else
        flash[:notice] = "Picture uploaded successfully!"

        require 'RMagick'
        username = self.current_user.login

        begin
          thumb = Magick::ImageList.new(path_for_picture(file_to_store, username))
          thumb.crop_resized!(get_setting('thumb_width').to_i)
          thumb.write(path_for_thumbnail(file_to_store, username))
        rescue Exception => e
          puts e.message

          FileUtils.rm_f(path_for_picture(file_to_store, username))
          FileUtils.rm_f(path_for_thumbnail(file_to_store, username))

          flash[:notice] = "This doesn't seem to be a valid picture!"
          return 2
        end

        return 0
      end
    end

end
