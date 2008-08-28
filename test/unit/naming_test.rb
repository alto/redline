require File.dirname(__FILE__) + '/../test_helper'

class NamingTest < ActiveSupport::TestCase

  context "Validating a naming" do
    should_require_attributes :user_id
    should_require_attributes :site_id
    should_require_attributes :person_id
  end

  context "A naming" do
    should_belong_to :user
    should_belong_to :site
    should_belong_to :person
  end
  
  context "Adding a naming" do
    should "create a corresponding command" do
      Command.delete_all
      naming = create_naming
      command = Command.find_by_action('added_naming')
      assert_not_nil command
      assert_equal naming, command.commandable
      assert_equal naming.user, command.user
    end
  end

  context "Removing a naming" do
    setup do
      @naming = create_naming
    end
    should "be logical" do
      @naming.delete!
      assert_not_nil Naming.find_by_id(@naming.id)
    end
    should "store its deletion date" do
      @naming.delete!
      assert_not_nil @naming.reload.deleted_at
    end
    should "be testable" do
      @naming.delete!
      assert @naming.reload.deleted?
    end
    should "create a corresponding command" do
      Command.delete_all
      @naming.delete!
      command = Command.find_by_action('removed_naming')
      assert_not_nil command
      assert_equal @naming, command.commandable
      assert_equal @naming.user, command.user
    end
  end

end
