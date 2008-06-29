class ConnectionsController < ApplicationController
  
  before_filter :login_required
  
  def create
    @connection = Connection.new(params[:connection])
    @connection.user = current_user
    @connection.save!
    redirect_to user_path(current_user)
  end
  
end
