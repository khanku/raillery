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

    File.open(path_to_picture(file_upload.original_filename), 'w') do |fh|
      fh.write(file_upload.read)
    end

    store(file_upload.original_filename, params[:image][:name])
  end

  def import
    
  end

  def download
    
  end

  def store(file_to_store, picture_name)
    require 'RMagick'

    # TODO: checks
    # MIME ?

    begin
      thumb = Magick::ImageList.new(path_to_picture(file_to_store))
      thumb.crop_resized!(get_setting('thumb_width').to_i)
      thumb.write(path_to_thumbnail(file_to_store))
    rescue Exception => e
      puts e.message

      flash[:notice] = "This doesn't seem to be a valid picture."
      redirect_to :action => 'new'
    end

    unless FileTest.exist?(path_to_thumbnail(file_to_store))
      return false;
    end

    pic = Picture.create(
      :name => picture_name || 'none',
      :path => file_to_store,
      :thumb_path => get_setting('thumb_path_prefix') + file_to_store,
      :user_id => self.current_user.id
    )
    pic.save!

    flash[:notice] = "Picture uploaded successfully!"
    redirect_to :action => 'index'
  end

  def terminate
    @picture = Picture.find(params[:id])
    if (self.current_user.id == @picture.user_id)

#
# TODO:
# - delete files
# - delete associated comments
#

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
  end

  protected
  def path_to_picture(picture_name)
    Rails.root.join(
      get_setting('public_pictures_directory'),
      picture_name
    )
  end
  
  def path_to_thumbnail(thumbnail_name)
    Rails.root.join(
      get_setting('public_pictures_directory'),
      get_setting('thumb_path_prefix'),
      thumbnail_name
    )
  end
end
