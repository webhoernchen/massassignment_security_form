class MassassignmentSecurityFormPerson < ActiveRecord::Base
  validates_presence_of :last_name
  belongs_to :seo, :class_name => self.to_s
  
  attr_accessible :first_name, :last_name, :birthday if respond_to?(:attr_accessible)

  accepts_nested_attributes_for :seo
end
