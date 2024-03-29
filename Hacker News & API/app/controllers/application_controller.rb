class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  helper_method :current_user

#
#  def authenticate
#  	redirect_to :login unless user_signed_in?
#  end
  
  def authenticate
   @user = User.where(oauth_token: request.headers['token'])
   if @user[0] == nil
     render :json => {"Error": "Unauthorized user"}.to_json, status: 401
   end
  end
 
  
  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_signed_in?
  	# converts current_user to a boolean by negating the negation
  	!!current_user
  end
end
