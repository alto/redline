require File.dirname(__FILE__) + '/../test_helper'

class CommandTest < ActiveSupport::TestCase

  context "Validating a command" do
    setup do
      @command = create_command
    end
  
    should_require_attributes :user_id
    should_require_attributes :action
  end

  context "A command" do
    should_belong_to :user
    should_belong_to :commandable
  end
  
  context "The command history" do
    setup do
      Time.advance_by_days = -1
      @yesterday_command = create_command
      Time.advance_by_days = 0
      @today_command = create_command
    end
    should "deliver the recent commands, most recent first" do
      assert_equal [@today_command, @yesterday_command], Command.history
    end
    should "deliver undone commands only" do
      @today_command.undo!
      assert_equal [@yesterday_command], Command.history
    end
    should "limit its number of entries if requested" do
      assert_equal 1, Command.history(:limit => 1).length
    end
    should "deliver a user's commands only if requested" do
      @today_command.update_attribute(:user, create_user(:login => 'other_user'))
      assert_equal [@yesterday_command], Command.history(:user => @yesterday_command.user)
    end
  end
  
  context "Undoing a command" do
    should "revoke an added claim" do
      claim = create_claim
      command = latest_command_for(claim)
      assert command.undo!
      assert_equal 1, Command.count
      assert command.undone?
      assert claim.reload.deleted?
    end
    should "revoke a removed claim" do
      Time.advance_by_days = -1
      claim = create_claim
      Time.advance_by_days = 0
      claim.delete!
      command = latest_command_for(claim)
      assert command.undo!
      assert_equal 2, Command.count
      assert command.undone?
      assert !claim.reload.deleted?
    end
  end
    
end
