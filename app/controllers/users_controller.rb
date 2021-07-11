class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update show destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @transaction = Transaction.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "User updated successfully"
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to root_path, notice: "User destroy successfully"
    else
      render :index
    end
  end

  private

  def user_params
    params.require(:user)
      .permit(:name, :email, :birthdate)
  end

  def set_user
    @user = User.find(params[:id])
    @transactions = @user.transactions.order(created_at: :desc)
    @credit_count = @user.transactions.transaction_count("credit")
    @debit_count = @user.transactions.transaction_count("debit")
    @credit = @user.transactions.transaction_value("credit")
    @debit = @user.transactions.transaction_value("debit")
  end
end
