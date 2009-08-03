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
    require 'RMagick'

    # TODO: checks
    # MIME ?

    file_upload = params[:file]
    pic_path = Rails.root.join(get_setting('public_pictures_directory'),
                               file_upload.original_filename)

    File.open(pic_path, 'w') do |fh|
      fh.write(file_upload.read)
    end

    thumb_path = Rails.root.join(
      get_setting('public_pictures_directory'),
      'thumb/',
      file_upload.original_filename
    )
    begin
      thumb = Magick::ImageList.new(pic_path)
      thumb.crop_resized!(get_setting('thumb_width').to_i)
      thumb.write(thumb_path)
    rescue Exception => e
      puts e.message

      flash[:notice] = "This doesn't seem to be a valid picture."
      redirect_to :action => 'new'
    end

    unless FileTest.exist?(thumb_path)
      return false;
    end

    pic = Picture.create(
      :name => params[:image][:name] || 'n/a',
      :path => file_upload.original_filename,
      :thumb_path => 'thumb/' + file_upload.original_filename,
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
      redirect_to :action => 'manage', :controller => 'browse'
    else
      flash[:notice] = "Sorry, this picture doesn't belong to you."
    end
  end

  def show
    @picture = Picture.find(params[:id])
  end

end
