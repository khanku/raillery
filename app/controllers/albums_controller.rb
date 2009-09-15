class AlbumsController < ApplicationController

  before_filter :login_required, :except => [ :show ]

  verify :method => :post,
         :except => [ :show, :new, :edit, :update ],
         :redirect_to => :root
  verify :method => :put, :only => :update


  # GET /albums
  # GET /albums.xml
  def index
    redirect_to :root
  end

  # GET /albums/1
  # GET /albums/1.xml
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

  # GET /albums/new
  # GET /albums/new.xml
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.xml
  def create
    @album = Album.new(params[:album])
    @album.user_id = self.current_user.id

    respond_to do |format|
      if @album.save
        flash[:notice] = 'Album was successfully created.'
        format.html { redirect_to(@album) }
        format.xml  { render :xml => @album, :status => :created, :location => @album }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @album.errors, :status => :unprocessable_entity }
      end
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
