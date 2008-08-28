require File.dirname(__FILE__) + '/../test_helper'

class ClaimTest < ActiveSupport::TestCase

  context "Validating a claim" do
    should_require_attributes :user_id
    should_require_attributes :site_id
  end

  context "A claim" do
    should_belong_to :user
    should_belong_to :site
  end
  
  context "Adding a claim" do
    should "create a corresponding command" do
      Command.delete_all
      claim = create_claim
      command = Command.find_by_action('added_claim')
      assert_not_nil command
      assert_equal claim, command.commandable
      assert_equal claim.user, command.user
    end
  end

  context "Removing a claim" do
    setup do
      @claim = create_claim
    end
    should "be logical" do
      @claim.delete!
      assert_not_nil Claim.find_by_id(@claim.id)
    end
    should "store its deletion date" do
      @claim.delete!
      assert_not_nil @claim.reload.deleted_at
    end
    should "be testable" do
      @claim.delete!
      assert @claim.reload.deleted?
    end
    should "create a corresponding command" do
      Command.delete_all
      @claim.delete!
      command = Command.find_by_action('removed_claim')
      assert_not_nil command
      assert_equal @claim, command.commandable
      assert_equal @claim.user, command.user
    end
  end
  
end
