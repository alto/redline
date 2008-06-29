class ClaimsController < ApplicationController

  before_filter :login_required
  
  def create
    @claim = Claim.new(params[:claim])
    @claim.user = current_user
    @claim.save!
    redirect_to user_path(current_user)
  end
  
end
