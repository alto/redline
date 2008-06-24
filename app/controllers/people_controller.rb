class PeopleController < ApplicationController
  
  before_filter :load_person
  
  def show
    @people = @person.combined_people.uniq
    @combinations = @person.created_combinations
    # @combinations = Combination.find(:all)
    @combination = Combination.new
  end
  
  private
    def load_person
      @person = Person.find(params[:id])
    end
  
end
