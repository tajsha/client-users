class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

  def map_result
    if current_user.role == 'admin'
      root = current_user.mapklubbs.where('parent_id is null').first
      mapables = root.descendants.where('latitude is not null and longitude is not null')
      @hash = Gmaps4rails.build_markers(mapables) do |mapable, marker|
        marker.lat mapable.latitude
        marker.lng mapable.longitude
      end
    else
      branches = current_user.branches
      mapables = []
      branches.each{|branch|
        mapables << branch.mapklubb.descendants.where('latitude is not null and longitude is not null')
      }
      @hash = Gmaps4rails.build_markers(mapables) do |mapable, marker|
        marker.lat mapable.latitude
        marker.lng mapable.longitude
      end
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end
