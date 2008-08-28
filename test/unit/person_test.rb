require File.dirname(__FILE__) + '/../test_helper'

class PersonTest < ActiveSupport::TestCase

  context "validating a person" do
    should_require_attributes :name
  end

  context "a person" do
    should_have_many :namings
    should_have_many :people
    should_have_many :sites
  end

end
