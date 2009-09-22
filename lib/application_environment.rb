module ApplicationEnvironment

  protected

    def get_setting(key)
      @setting = Setting.find(:first, :conditions => ["key = ?", key], :limit => 1 )
      return @setting.value
    end

    def path_for_thumbnail(thumbnail_name, username)
      path = Rails.root.join(
        get_setting('public_pictures_directory'),
        get_setting('thumb_path_prefix'),
        username
      )

      FileUtils.mkdir_p(path) if !File.exist?(path)

      path + thumbnail_name
    end

    def path_for_picture(picture_name, username)
      path = Rails.root.join(
        get_setting('public_pictures_directory'),
        username
      )

      FileUtils.mkdir_p(path) if !File.exist?(path)

      path + picture_name
    end

    def path_to_thumbnail(thumbnail_name)
      Rails.root.join(
        get_setting('public_pictures_directory'),
        get_setting('thumb_path_prefix'),
        self.user.login,
        thumbnail_name
      )
    end

    def path_to_picture(picture_name)
      Rails.root.join(
        get_setting('public_pictures_directory'),
        self.user.login,
        picture_name
      )
    end

end
