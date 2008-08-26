ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + "/factories")

class Test::Unit::TestCase
  include AuthenticatedTestHelper

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

end

require 'time'
if !Time.respond_to?('now_old')
  Time.class_eval {
    @@advance_by_days = 0
    @@advance_by_minutes = 0
    cattr_accessor :advance_by_days, :advance_by_minutes

    class << Time
      alias now_old now
      def now
        if Time.advance_by_days != 0
          return Time.at(now_old.to_i + Time.advance_by_days * 60 * 60 * 24 + 1)
        elsif Time.advance_by_minutes != 0
          return Time.at(now_old.to_i + Time.advance_by_minutes * 60)
        else
          now_old
        end
      end
    end
  }
end
