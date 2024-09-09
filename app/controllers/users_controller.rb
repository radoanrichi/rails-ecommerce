class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def show
    redirect_to edit_user_path if current_user != @user && !current_user.admin?
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: I18n.t('users.update.success')
    else
      render :edit, alert: I18n.t('users.update.failed')
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: I18n.t('users.destroy.success')
    else
      redirect_to users_path, alert: I18n.t('users.destroy.failed')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:role)
  end

  def authorize_admin
    redirect_to root_path, alert: I18n.t('users.access_denied') unless current_user&.admin?
  end
end
