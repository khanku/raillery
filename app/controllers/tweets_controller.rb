class TweetsController < ApplicationController

  before_filter :login_required
  verify :method => :post,
         :except => [ :new ],
         :redirect_to => { :controller => '/' }

  layout nil

  def new
    @tweet = Tweet.new
    @tweet.picture_id = params[:id]
  end

  def create
    begin
      p = Picture.find(params[:tweet][:picture_id], :limit => 1)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "This picture doesn't exist!"
    end

    if params[:tweet][:message].empty?
      flash[:notice] = "Please write something."
    elsif p.nil?
      redirect_to :root
    else
      tweet = Tweet.create(
        :message => params[:tweet][:message],
        :user_id => self.current_user.id,
        :picture_id => params[:tweet][:picture_id]
      )
      tweet.save

      if !tweet.errors.empty?
        flash[:notice] << get_errors_for(tweet)
      end
    end

    redirect_to picture_path(p)
  end

end
