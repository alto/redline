class NamingsController < ApplicationController
  
  before_filter :login_required
  before_filter :load_user, :only => [:show,:index]
  
  def index
    respond_to do |format|
      format.xml {render :xml => @user.namings}
    end
  end
  
  def create
    @naming = Naming.new(params[:naming])
    @naming.user = current_user
    @naming.save!
    redirect_to user_path(current_user)
  end
  
  private
    def load_user
      @user = User.find_by_url_slug(params[:user_id])
    end
  
end
