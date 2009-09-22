class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  def new
  end

  def new_ajax
    render :action => 'new_ajax', :layout => false
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def show
    user = User.find(params[:id])
    @username = user.login

    @page = params[:page].to_i ||= 1
    if (@page < 1)
      @page = 1
    end

    @pictures_per_page = get_setting('pictures_per_page').to_i
    offset = (@page - 1) * @pictures_per_page

    @albums = Album.find_all_by_user_id(user.id,
              :order  => "created_at DESC",
              :limit  => @pictures_per_page,
              :offset => offset
             )
    @pictures_count = user.albums.count  # for pagination only
    @pictures_in_a_row = get_setting('pictures_in_a_row').to_i

    render :action => 'show', :layout => 'users_show'
  end

  def index
   @users_count = User.count
  end
end
