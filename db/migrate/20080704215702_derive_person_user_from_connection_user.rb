class DerivePersonUserFromConnectionUser < ActiveRecord::Migration
  def self.up
    Person.find(:all).each do |p|
      if p.connections.empty?
        p.destroy
      else
        p.user = p.connections.first.user
        p.save!
      end
    end
  end

  def self.down
  end
end
