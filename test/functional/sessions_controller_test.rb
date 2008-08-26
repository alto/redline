require File.dirname(__FILE__) + '/../test_helper'

class SessionsControllerTest < ActionController::TestCase

  context "Routing" do
    should "route new requests" do
      assert_routing '/session/new', :controller => 'sessions', :action => 'new'
    end
    should "route create requests" do
      assert_routing({:path => '/session',:method => 'post'}, {:controller => 'sessions', :action => 'create'})
    end
    should "route destroy requests" do
      assert_routing({:path => '/session',:method => 'delete'},{ :controller => 'sessions', :action => 'destroy'})
    end
  end

  context "Request to new" do
    should "be successfull" do
      get :new
      assert_response :success
      assert_template 'new'
    end
  end
  
  context "Request to create a session" do
    setup do
      @user = create_active_user
    end
    should "be successfull" do
      post :create, :login => 'dude', :password => 'password'
      assert_redirected_to user_path(@user)
    end
    should "fail if login is unknown is wrong" do
      post :create, :login => 'unknown'
      assert_nil session[:user_id]
      assert_template 'new'
    end
    should "fail if password is wrong" do
      post :create, :login => 'dude', :password => 'wrong'
      assert_template 'new'
    end
    should "fail if user is inactive" do
      inactive = create_user(:login => 'inactive')
      post :create, :login => 'inactive', :password => 'password'
      assert_template 'new'
    end
    should "remember the user if requested" do
      post :create, :login => 'dude', :password => 'password', :remember_me => '1'
      assert_not_nil @user.reload.remember_token_expires_at
      assert_not_nil @user.remember_token
      assert_not_nil @response.cookies["auth_token"]
    end
    should "login with cookie" do
      @user.remember_me
      @request.cookies['auth_token'] = cookie_for(@user)
      get :new
      assert @controller.send(:logged_in?)
    end
    should "not login with cookie if expired" do
      @user.remember_me
      @user.update_attribute(:remember_token_expires_at, 5.minutes.ago)
      @request.cookies['auth_token'] = cookie_for(@user)
      get :new
      assert !@controller.send(:logged_in?)
    end
    should "not login with invalid token" do
      @user.remember_me
      @request.cookies['auth_token'] = auth_token('invalid_auth_token')
      get :new
      assert !@controller.send(:logged_in?)
    end
  end

  context "Request to destroy a session (logout)" do
    setup do
      @user = create_active_user
      login_as(@user)
    end
    should "be successfull" do
      delete :destroy
      assert_nil session[:user_id]
      assert_redirected_to root_path
    end
    should "delete token on logout" do
      delete :destroy
      assert_equal @response.cookies["auth_token"], []
    end
  end

  private
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    def cookie_for(user)
      auth_token user.remember_token
    end
end
