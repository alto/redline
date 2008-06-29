class UsersController < ApplicationController

  before_filter :login_required, :only => [:show,:edit,:update,:destroy]

  def show
    @user = User.find(params[:id])
    @claims = @user.claims
    @claim = Claim.new
    @people = @user.people.uniq
    @connections = @user.connections
  end

  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    unless @user.update_attributes(params[:user])
      render :action => 'edit' and return
    end
    redirect_to user_path(@user)
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

end
