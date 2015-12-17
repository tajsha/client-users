class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show

  def index
    @users = User.all
  end

  def map_result
    if request.xhr?
      address_ids=[]
      filter_condition = if params['country'].present?
                            "mapable_id IN (select id from addresses where country IN (#{params['country'].map { |s| "'#{s}'" }.join(',')})) "+
                            "AND mapable_type = 'Address' AND latitude is not null and longitude is not null"
                         else
                           'latitude is not null and longitude is not null'
                         end
      if current_user.role == 'admin'
        root = current_user.mapklubbs.where('parent_id is null').first
        mapables = root.descendants.where(filter_condition)
      else
        branches = current_user.branches
        mapables = []
        branches.each{|branch|
          mapables << branch.mapklubb.descendants.where(filter_condition)
        }
      end
      @hash = mapable_data(mapables)
      render :json => @hash
    else
      if current_user.role == 'admin'
        root = current_user.mapklubbs.where('parent_id is null').first
        mapables = root.descendants.where('latitude is not null and longitude is not null')
        address_ids = []
        mapables.each{|m| address_ids << m.mapable_id if m.mapable_type == 'Address'}
        @countries = Address.select(:country).where(:id => address_ids).map(&:country).uniq
      else
        branches = current_user.branches
        mapables = []
        branches.each{|branch|
          mapables << branch.mapklubb.descendants.where('latitude is not null and longitude is not null')
        }
        address_ids = []
        mapables.each{|m| address_ids << m.mapable_id if m.mapable_type == 'Address'}
        @countries = Address.select(:country).where(:id => address_ids).map(&:country).uniq
      end
      @hash = mapable_data(mapables)
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

  def mapable_data(mapables)
    Gmaps4rails.build_markers(mapables) do |mapable, marker|
      marker.lat mapable.latitude
      marker.lng mapable.longitude
    end
  end

end
