class UsersController < ApplicationController

  def show
    @user = User.find(current_user.id)
  end

  def new
  end

  def edit
    @user = User.find(current_user.id)
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to '/transactions/new'
    else
      redirect_to '/signup'
    end
  end

# post 'localhost:3000/users/addTime?time=0700'
  def addTime
    if request.get? 
      puts "THIS IS A GET REQUEST"
      param_time = "'" + params[:time].to_s  + "'"
      puts "time is #{param_time}"
      # puts param_time.class
      # wakeup_time = Time.parse(param_time)
      wakeup_time = DateTime.parse(param_time)
      puts "THIS IS THE WAKEUP TIME #{wakeup_time}"

      #Save to user
      current_user.wakeup_time = wakeup_time
      current_user.save

      puts "current user #{current_user.wakeup_time}"
    else 
      puts "no idea you idiot"
    end    

  end

private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :user_number, :friend_number, :braintree_id)
  end
end