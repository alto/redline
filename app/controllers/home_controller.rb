class HomeController < ApplicationController

  def index
    @users = User.find(:all)
  end

end
