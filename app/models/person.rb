class Person < ActiveRecord::Base
    
  validates_presence_of :name
  
  belongs_to :user
  
  has_many :combinations
  has_many :people, :through => :combinations
  has_many :sites, :through => :combinations
  
  has_many :created_combinations, :class_name => 'Combination', :foreign_key => 'created_by'
  has_many :combined_people, :through => :created_combinations, :source => :person
  
end
