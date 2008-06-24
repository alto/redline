class HomeController < ApplicationController

  def index
    @combinations = Combination.find(:all)
    @combination = Combination.new
  end

end
