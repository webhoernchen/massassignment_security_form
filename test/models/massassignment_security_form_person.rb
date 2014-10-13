class MassassignmentSecurityFormPerson < ActiveRecord::Base
  validates_presence_of :last_name
  belongs_to :seo, :class_name => self.to_s
  has_many :employees, :class_name => self.to_s, :foreign_key => 'seo_id'
  
  attr_accessible :first_name, :last_name, :birthday, :seo_attributes, 
    :employees_attributes if respond_to?(:attr_accessible)

  accepts_nested_attributes_for :seo, :employees
end
