class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new 
    @user = User.new 
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully"
    else
      render :new 
    end
  end

  def edit;end

  def update
    # TODO: update user
    byebug
  end


  private 

  def user_params 
    params.require(:user)
    .permit(:name,:email,:birthdate)
  end
end
