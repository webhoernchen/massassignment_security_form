ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

require File.expand_path(File.dirname(__FILE__) + "/../../../test/test_helper")

Dir[File.expand_path(File.dirname(__FILE__) + "/../../../test/**/*_test.rb")].sort.each do |model|
  require model
end

#class ActiveSupport::TestCase
#end
