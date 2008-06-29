class CombinationsController < ApplicationController
  
  before_filter :login_required
  
  def create
    @combination = Combination.new(params[:combination])
    @combination.user = current_user
    @combination.save!
    redirect_to root_path
  end
  
end
