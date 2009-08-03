class TweetsController < ApplicationController

  before_filter :login_required, :except => [ :new, :create ]
  verify :method => :post,
         :except => [ :new, :show ],
         :redirect_to => { :action => 'show' }

  def show
    @tweets = Tweet.find_all_by_picture_id(params[:id])
  end

  def new
    @tweet = Tweet.new
    @tweet.picture_id = params[:id]
  end

  def create
    p = Picture.find(params[:tweet][:picture_id], :limit => 1)
    if p.nil?
      flash[:notice] = 'invalid picture id'
      redirect_to :root
    end

    @tweet = Tweet.create(
      :message => params[:tweet][:message],
      :user_id => self.current_user.id,
      :picture_id => params[:tweet][:picture_id]
    )
    @tweet.save!

    redirect_to :root
  end
end
