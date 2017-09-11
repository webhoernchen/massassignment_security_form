require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'mocha'

require File.expand_path(File.dirname(__FILE__) + "/test_tables")

Dir.glob(File.expand_path(File.dirname(__FILE__) + "/models/*.rb")).sort.each {|file| require file.gsub(".rb", "") }

module MassassignmentSecurityFormTestCase
  def self.included(base)
    base.class_eval do
      extend TestTables

      create_tables
    end
  end
end

MassassignmentSecurityForm::Config.password = 'test123honk456'

class ActiveSupport::TestCase
  include MassassignmentSecurityFormTestCase

  if self.respond_to? :use_transactional_fixtures=
    self.use_transactional_fixtures = true
  else
    self.use_transactional_tests = true
  end

  self.use_instantiated_fixtures  = false
end
