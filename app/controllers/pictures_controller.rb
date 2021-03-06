class PicturesController < ApplicationController

  before_filter :login_required, :except => [ :show ]

  verify :method => :post,
         :except => [ :show, :new, :edit, :update ],
         :redirect_to => { :action => 'index' }
  verify :method => :put, :only => :update

  include PictureStorage

  def new
    if Album.find_by_user_id(self.current_user.id).nil?
      flash[:notice] = 'Please create an album first.'
      redirect_to new_album_path
    end

    @user = self.current_user
  end

  def create
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

      if ( store(file_upload.original_filename, params[:picture][:name],
             params[:picture][:album_id]) != 0 )

        FileUtils.rm_f(path_for_picture(file_upload.original_filename, username))
        redirect_to :controller => 'pictures', :action => 'new'
      else
        redirect_to :controller => 'managers', :action => 'own'
      end
    end
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
