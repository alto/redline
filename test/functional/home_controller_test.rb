require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

class HomeControllerTest < ActionController::TestCase
  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
