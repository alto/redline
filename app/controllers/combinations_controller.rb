class CombinationsController < ApplicationController
  
  def create
    @combination = Combination.new(params[:combination])
    @combination.save
    redirect_to root_path
  end
  
end
