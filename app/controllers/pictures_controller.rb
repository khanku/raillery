class PicturesController < ApplicationController

  before_filter :login_required, :except => [ :index, :show ]
  verify :method => :post,
         :except => [ :index, :show, :new ],
         :redirect_to => { :action => 'index' }

  def index
    redirect_to :root
  end

  def new
  end

  def create
    file_upload = params[:file]
    username = self.current_user.login

    if FileTest.exist?(path_for_picture(file_upload.original_filename, username)) \
         || FileTest.exist?(path_for_thumbnail(file_upload.original_filename, username))

      flash[:notice] = "This file (or a file with the same name) already exists!"
      redirect_to :action => 'new'
    else
      File.open(path_for_picture(file_upload.original_filename, username), 'w') do |fh|
        fh.write(file_upload.read)
      end

      store(file_upload.original_filename, params[:image][:name])
    end
  end

  def import
    
  end

  def download
    
  end

  def store(file_to_store, picture_name)
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

    if picture_name.empty?
      picture_name = 'unnamed picture'
    end

    pic = Picture.create(
      :name => picture_name,
      :filename => file_to_store,
      :user_id => self.current_user.id
    )
    pic.save!

    flash[:notice] = "Picture uploaded successfully!"
    redirect_to :controller => 'managers', :action => 'own'
  end

  def terminate
    @picture = Picture.find(params[:id])

    if (self.current_user.id == @picture.user_id)
      @picture.destroy
      @errors = get_errors_for(@picture) if !@picture.errors.empty?

      flash[:notice] = ''

      if @errors
        flash[:notice] += @errors
      end

      flash[:notice] += "Picture deleted successfully!"
      redirect_to :controller => 'managers', :action => 'own'
    else
      flash[:notice] = "Sorry, this picture doesn't belong to you."
    end
  end

  def show
    @picture = Picture.find(params[:id])
    @user = @picture.user

    # custom layout with some more JS
    render :layout => 'pictures_show'
  end
end
