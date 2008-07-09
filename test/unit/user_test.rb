require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase

  context "Validating a user" do
    setup do
      @user = Factory(:user)
    end
  
    should_require_attributes :login
    should_require_attributes :email

    should "validate the presence of the password if the password is required" do
      @user.crypted_password = nil
      @user.password = nil
      assert !@user.valid?
    end
    should "not validate the presence of the password if the password is not required" do
      @user.password = nil
      assert @user.valid?
    end
    should "validate the presence of the password confirmation if the password is required" do
      @user.password = 'new_password'
      @user.password_confirmation = nil
      assert !@user.valid?
    end
    should "validate the length of the password to be no shorter than 4 characters" do
      @user.password = @user.password_confirmation = '123'
      assert !@user.valid?
      @user.password = @user.password_confirmation = '1234'
      assert @user.valid?
    end
    should "validate the length of the password to be no longer than 40 characters" do
      @user.password = @user.password_confirmation = '12345678901234567890123456789012345678901'
      assert !@user.valid?
      @user.password = @user.password_confirmation = '1234567890123456789012345678901234567890'
      assert @user.valid?
    end
    should "validate the confirmation of the password if password is provided" do
      @user.password = 'new_password'
      @user.password_confirmation = 'old_password'
      assert !@user.valid?
    end

    should_ensure_length_in_range :login, (3..40)
    should_ensure_length_in_range :email, (3..100)

    should_require_unique_attributes :login
    should_require_unique_attributes :email
  end
  
  # context "A user" do
  #   should_have_many :sites
  # end
  
  context "User authentication" do
    should "provide a check method" do
      assert_respond_to User.new, :authenticated?
    end
  end

  context "Creating a user" do
    setup do
      @user = Factory(:user)
    end
    should "store it in the database" do
      assert !@user.new_record?
    end
    should "initialize the activation code" do
      assert_not_nil @user.activation_code
    end
  end
  
  context "Updating a user" do
    setup do
      @user = Factory(:user)
      @user.activate
    end
    should "update the password" do
      @user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      assert_equal @user, User.authenticate(@user.login, 'new password')
    end
    should "not rehash the password" do
      @user.update_attributes(:login => 'new_login')
      assert_equal @user, User.authenticate('new_login', 'password')
    end
  end
  
  context "User authentication" do
    setup do
      @user = Factory(:user)
      @user.activate
    end
    should "be successfull" do
      assert_equal @user, User.authenticate('dude', 'password')
    end
    should "allow setting of remember token" do
      @user.remember_me
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
    end
    should "unset remember token" do
      @user.remember_me
      assert_not_nil @user.remember_token
      @user.forget_me
      assert_nil @user.remember_token
    end
    should "remember me for one week" do
      before = 1.week.from_now.utc
      @user.remember_me_for 1.week
      after = 1.week.from_now.utc
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
      assert @user.remember_token_expires_at.between?(before, after)
    end
    should "remember me until one week" do
      time = 1.week.from_now.utc
      @user.remember_me_until time
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
      assert_equal @user.remember_token_expires_at, time
    end
    should "remember me defsult two weeks" do
      before = 2.weeks.from_now.utc
      @user.remember_me
      after = 2.weeks.from_now.utc
      assert_not_nil @user.remember_token
      assert_not_nil @user.remember_token_expires_at
      assert @user.remember_token_expires_at.between?(before, after)
    end
  end

end
