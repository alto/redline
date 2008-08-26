require File.dirname(__FILE__) + '/../test_helper'

class UsersControllerTest < ActionController::TestCase

  context "Users routing" do
    should "route user show requests" do
      assert_routing '/users/dude', :controller => 'users', :action => 'show', :id => 'dude'
    end
    should "route user new requests" do
      assert_routing '/users/new', :controller => 'users', :action => 'new'
    end
    should "route user create requests" do
      assert_routing({:path => '/users',:method => 'post'}, {:controller => 'users', :action => 'create'})
    end
    should "route user edit requests" do
      assert_routing '/users/dude/edit', :controller => 'users', :action => 'edit', :id => 'dude'
    end
    should "route user update requests" do
      assert_routing({:path => '/users/dude',:method => 'put'}, {:controller => 'users', :action => 'update', :id => 'dude'})
    end
    should "route user activation requests" do
      assert_routing '/activate/code', :controller => 'users', :action => 'activate', :activation_code => 'code'
    end    
  end

  context "Request to show" do
    setup do
      @user = create_active_user
    end
    should "be successfull" do
      get :show, :id => @user.to_param
      assert_response :success
    end
    # should "deliver the user's towwls" do
    #   towwl = create_towwl(:user => @user)
    #   get :show, :id => @user.to_param
    #   assert_equal [towwl], assigns(:towwls)
    # end
  end
  
  context "Request to new" do
    should "be successfull" do
      get :new, :inviter => 'inviter'
      assert_redirected_to new_user_path
    end
    should "require an inviter" do
      get :new
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
  end
  
  context "Request to create" do
    setup do
      @inviter = create_user(:login => 'inviter')
    end
    should "require an inviter" do
      post :create
      assert_redirected_to root_path
      assert_not_nil flash[:error]
    end
    should "be successfull" do
      post :create, :user => user_fields, :inviter => 'inviter'
      assert_response :redirect
      assert_nil flash[:error]
    end
    should "create the new user" do
      post :create, :user => user_fields, :inviter => 'inviter'
      follow_redirect
      new_user = User.find_by_login(user_fields[:login])
      assert_not_nil new_user
      assert_equal user_fields[:email], new_user.email
    end
    should "create a non-active user" do
      post :create, :user => user_fields, :inviter => 'inviter'
      follow_redirect
      new_user = User.find_by_login(user_fields[:login])
      assert !new_user.active?
    end
    should "fail if user is invalid" do
      post :create, :user => user_fields.merge(:password => 'wrong_password'), :inviter => 'inviter'
      follow_redirect
      assert_template 'new'
    end
    should "store the inviter" do
      post :create, :user => user_fields, :inviter => 'inviter'
      follow_redirect
      new_user = User.find_by_login(user_fields[:login])
      assert_equal @inviter, new_user.inviter
    end
  end

  context "Request to edit" do
    setup do
      @user = create_user
    end
    should "require a logged in user" do
      get :edit
      assert_redirected_to new_session_path
    end
    should "be successfull" do
      login_as(@user)
      get :edit
      assert_response :success
    end
    should "deliver the logged in user" do
      login_as(@user)
      get :edit
      assert_equal @user, assigns(:user)
    end
  end
  
  context "Request to update a user" do
    setup do
      @user = create_user
    end
    should "require a logged in user" do
      put :update, :id => @user.to_param
      assert_redirected_to new_session_path
    end
    should "be successfull" do
      login_as(@user)
      put :update, :id => @user.to_param, :user => {}
      assert_redirected_to user_path(@user)
    end
    should "fail if user is invalid" do
      login_as(@user)
      put :update, :id => @user.to_param, :user => {:email => nil}
      assert_template 'edit'
      assert_equal @user, assigns(:user)
    end
  end
  
  context "Request to activate a user" do
    setup do
      @user = create_user
    end
    should "be successfull" do
      get :activate, :activation_code => @user.activation_code
      assert_redirected_to root_path
      assert_not_nil flash[:notice]
    end
    should "activate the requested user" do
      get :activate, :activation_code => @user.activation_code
      assert @user.reload.active?
    end
    should "log in the requested user" do
      get :activate, :activation_code => @user.activation_code
      assert @controller.send(:logged_in?)
    end
    should "fail if no activation code provided" do
      get :activate, :activation_code => nil
      assert_redirected_to root_path
      assert_nil flash[:notice]
    end
    should "fail if activation code is blank" do
      get :activate, :activation_code => ''
      assert_redirected_to root_path
      assert_nil flash[:notice]
    end
    should "fail if there is no corresponding user" do
      get :activate, :activation_code => 'any_code'
      assert_redirected_to root_path
      assert_nil flash[:notice]
    end
  end

end
