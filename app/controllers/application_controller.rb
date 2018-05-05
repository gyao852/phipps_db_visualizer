class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: 'You need to log in to view this page.' if current_user.nil?
  end

  def search
    @nav_status = 'db'
    @q = "%#{params[:query]}%"
    @result_constituents = Constituent.where("name LIKE ? or lookup_id LIKE ? or last_group LIKE ? or email_id LIKE ? or phone LIKE ?",
      @q, @q, @q, @q, @q).paginate(:page => params[:page], :per_page => 30)
  end

  def search_unclean
    @nav_status = 'review'
    @q = "%#{params[:query]}%"
    @result_unclean_constituents = UncleanConstituent.where("name LIKE ? or lookup_id LIKE ? or last_group LIKE ? or email_id LIKE ? or phone LIKE ?",
      @q, @q, @q, @q, @q).paginate(:page => params[:page], :per_page => 30)
  end

end
