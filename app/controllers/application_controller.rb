class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:user_id] && (User.all.count!=0)
      puts User.find(session[:user_id])
      if User.find(session[:user_id]) 
        @current_user = User.find(session[:user_id])
       else
        @current_user = false
       end
    end
  end
  helper_method :current_user

  def authorize
    redirect_to '/login' unless current_user
  end

end