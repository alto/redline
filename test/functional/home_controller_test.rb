require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase

  context "Routing" do
    should "route home index requests" do
      assert_routing '/', :controller => 'home', :action => 'index'
    end
  end
  
  context "Request to index" do
    should "deliver users" do
      user = create_user
      get :index
      assert_equal [user], assigns(:users)
    end
  end
end
