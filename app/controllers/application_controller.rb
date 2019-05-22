class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout proc { google_logged_in ? "glogged_in" : "application" }
  before_action :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
  

  def index
    render json: {session: session}
  end

  def current_user
	 @current_user ||= User.find(session["warden.user.user.key"][0][0])

  end

  def is_user_logged_in?
	#complete this method
  
    logged_in = current_user
	 if current_user then true else redirect_to root_path end 
  end

  def google_logged_in
    if session["warden.user.user.key"] then true else false end
  end
end
