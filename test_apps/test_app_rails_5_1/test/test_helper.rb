ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")

p File.expand_path(File.dirname(__FILE__) + "/../../../test/**/*_test.rb")
Dir[File.expand_path(File.dirname(__FILE__) + "/../../../test/**/*_test.rb")].sort.each do |model|
  require model
end

#class ActiveSupport::TestCase
#  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
#  fixtures :all
#
#  # Add more helper methods to be used by all tests here...
#end
