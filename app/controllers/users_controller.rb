class UsersController < ApplicationController

  before_filter :login_required, :only => [:edit,:update,:destroy]
  before_filter :inviter_required, :only => [:new,:create]

  def show
    @user = User.find_by_url_slug(params[:id])
    @linked_people = @user.people.uniq
    @created_connections = @user.connections
    @linking_users = User.find_linking_to(@user)
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
    @user.inviter = User.find_by_login(session[:inviter]) unless session[:inviter].blank?
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
  
  private
    def inviter_required
      invitation_only if session[:inviter].blank?
    end

    def invitation_only
      respond_to do |format|
        format.html do
          store_location
          flash[:error] = 'You need an invitation!'
          redirect_to root_path
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

end
