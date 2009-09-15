class PicturesController < ApplicationController

  before_filter :login_required, :except => [ :show ]

  verify :method => :post,
         :except => [ :show, :new, :edit, :update ],
         :redirect_to => { :action => 'index' }
  verify :method => :put, :only => :update

  def new
    if Album.find_by_user_id(self.current_user.id).nil?
      flash[:notice] = 'Please create an album first.'
      redirect_to new_album_path
    end

    @user = self.current_user
  end

  def create
    if params[:picture][:file].nil?
      flash[:notice] = "Please specify a picture to upload!"
      redirect_to :action => 'new'
    elsif params[:picture][:name].empty?
      flash[:notice] = "Please give a name to the picture you want to upload."
      redirect_to :action => 'new'
    elsif !self.current_user.album_ids.include?(params[:picture][:album_id].to_i)
      flash[:notice] = "Choose one of your albums, please."
      redirect_to :action => 'new'
    else
      file_upload = params[:picture][:file]
      username = self.current_user.login

      if FileTest.exist?(path_for_picture(file_upload.original_filename, username)) \
          || FileTest.exist?(path_for_thumbnail(file_upload.original_filename, username))

        flash[:notice] = "This file (or a file with the same name) already exists!"
        redirect_to :action => 'new'
      else
        File.open(path_for_picture(file_upload.original_filename, username), 'w') do |fh|
          fh.write(file_upload.read)
        end

        store(file_upload.original_filename,
              params[:picture][:name],
              params[:picture][:album_id]
             )
      end
    end
  end

  def import
    
  end

  def download
    
  end

  def store(file_to_store, picture_name, album_id)
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
      redirect_to :controller => 'managers'
    end

    unless FileTest.exist?(path_for_thumbnail(file_to_store, username))
      return false;
    end

    pic = Picture.create(
      :name => picture_name,
      :filename => file_to_store,
      :user_id => self.current_user.id,
      :album_id => album_id
    )
    pic.save

    errors = get_errors_for(pic) if !pic.errors.empty?

    flash[:notice] = ''
    if errors
      flash[:notice] += errors
    else
      flash[:notice] = "Picture uploaded successfully!"
    end

    redirect_to :controller => 'managers', :action => 'own'
  end

  def terminate
    @picture = Picture.find(params[:id])

    if (self.current_user.id == @picture.user_id)
      @picture.destroy
      errors = get_errors_for(@picture) if !@picture.errors.empty?

      flash[:notice] = ''
      if errors
        flash[:notice] += errors
      end

      flash[:notice] += "Picture deleted successfully!"
      redirect_to :controller => 'managers', :action => 'own'
    else
      flash[:notice] = "Sorry, this picture doesn't belong to you."
    end
  end

  def show
    begin
      @picture = Picture.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'This picture does not exist!'
    end

    if @picture.nil?
      redirect_to :root
    else

      @user = @picture.user

      # custom layout with some more JS
      render :layout => 'pictures_show'
    end
  end

  def edit
    @picture = Picture.find(params[:id])
    @user = self.current_user
  end

  def update
    @picture = Picture.find(params[:id])

    if @picture.update_attributes(params[:picture])
      flash[:notice] = 'Picture successfully updated.'
      redirect_to own_managers_path
    else
      render :action => 'edit'
    end
  end

end
