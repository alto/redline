module ActsAsDeletable
  module ActMethods
    def acts_as_deletable(options={})
      unless included_modules.include? InstanceMethods
        class_inheritable_accessor :options
        include InstanceMethods
      end
      self.options = options
    end
  end

  module InstanceMethods
    def delete!(do_callbacks=true)
      if self.update_attribute(:deleted_at, Time.now)
        if options[:with]
          options[:with] = [options[:with]] unless options[:with].is_a?(Array)
          options[:with].each do |with|
            with_objects = self.send(with)
            if with_objects.is_a?(Array)
              with_objects.each {|with_object| with_object.delete! if with_object.respond_to?(:delete!) }
            else
              with_objects.delete! if with_objects.respond_to?(:delete!)
            end
          end
        end
        if do_callbacks && options[:after]
          options[:after] = [options[:after]] unless options[:after].is_a?(Array)
          options[:after].each do |after|
            self.send(after)
          end
        end
        true
      else
        false
      end
    end
    def undelete!
      self.update_attribute(:deleted_at, nil)
    end
    def deleted?
      !self.deleted_at.nil?
    end
  end
  
  class RecordDeleted < StandardError; end
  

end

ActiveRecord::Base.extend ActsAsDeletable::ActMethods
