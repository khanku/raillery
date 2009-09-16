class AlbumsController < ApplicationController

  before_filter :login_required, :except => [ :index, :show ]

  verify :method => :post,
         :except => [ :index, :show, :new, :edit, :update ],
         :redirect_to => { :controller => 'browse' }
  verify :method => :put, :only => :update


  def index
    if !logged_in?
      flash[:notice] = 'Please login to manage your albums.'
      redirect_to :root
    else
      @albums = self.current_user.albums
    end
  end

  def show
    begin
      @album = Album.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = 'This album does not exist!'
    end

    if @album.nil?
      redirect_to :root 
    else

      @page = params[:page].to_i ||= 1
      if (@page < 1)
        @page = 1
      end

      @pictures_per_page = get_setting('pictures_per_page').to_i
      offset = (@page - 1) * @pictures_per_page

      @pictures = Picture.find_all_by_album_id(
                    params[:id],
                    :order  => "created_at DESC",
                    :limit  => @pictures_per_page,
                    :offset => offset
                  )

      @pictures_count = @album.pictures.count
      @pictures_in_a_row = get_setting('pictures_in_a_row').to_i
    end
  end

  def new
    @album = Album.new
  end

  def edit
    @album = Album.find(params[:id])
  end

  def create
    @album = Album.new(params[:album])
    @album.user_id = self.current_user.id

    if @album.save
      flash[:notice] = 'Album was successfully created.'
      redirect_to managers_path
    else
      render :action => "new"
    end
  end

  # PUT /albums/1
  # PUT /albums/1.xml
  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        flash[:notice] = 'Album was successfully updated.'
        format.html { redirect_to(@album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.xml
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to(albums_url) }
      format.xml  { head :ok }
    end
  end
end
