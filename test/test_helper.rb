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
  def create_user(options={})
    user = build_user(options)
    user.save!
    user.person = options[:person] || create_person
    user.person.save!
    user
  end

  def build_person(options={})
    options[:name] ||= 'person name'
    Person.new(options)
  end
  def create_person(options={}); (o = build_person(options)).save!; o; end

end

