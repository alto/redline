ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  include AuthenticatedTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def build_user(options={})
    fields = {}
    fields[:login]      = options[:login]     || 'dude'
    fields[:email]      = options[:email]     || "#{fields[:login]}@test.com"
    fields[:password]   = options[:password]  || 'password'
    fields[:password_confirmation] = options[:password_confirmation] || fields[:password]
    User.new(fields)
  end
  def create_user(options={}); (u = build_user(options)).save!; u; end

end

