require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase

  context "validating a site" do
    should_require_attributes :url
  end

  context "a site" do
    should_have_many :namings
    should_have_many :namers
    should_have_many :people
    should_have_many :claims
    should_have_many :claimers
  end

end
