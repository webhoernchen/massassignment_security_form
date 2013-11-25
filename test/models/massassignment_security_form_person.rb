class MassassignmentSecurityFormPerson < ActiveRecord::Base
  validates_presence_of :last_name
  
  attr_accessible :first_name, :last_name if respond_to?(:attr_accessible)
end
