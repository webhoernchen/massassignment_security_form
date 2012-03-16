# -*- encoding: utf-8 -*-
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require "massassignment_security_form/version"

Gem::Specification.new do |s|
  s.name        = "massassignment_security_form"
  s.version     = MassassignmentSecurityForm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christian Eichhorn"]
  s.email       = ["c.eichhorn@webmasters.de"]
  s.homepage    = ["http://www.webmasters.de"]
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "massassignment_security_form"
  s.files         = Dir.glob(File.expand_path("../**/*", __FILE__)).select {|f| File.file?(f) }.collect {|f| f.gsub(File.expand_path("../", __FILE__) + '/', '') }
  s.test_files    = []
  s.executables   = []
  s.require_paths = ["lib"]
  
  if s.respond_to? :specification_version then
    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency('rails', ">= 2.3")
      s.add_runtime_dependency('actionpack', ">= 2.3")
    else
      s.add_dependency('rails', ">= 2.3")
      s.add_dependency('actionpack', ">= 2.3")
    end
  else
    s.add_dependency('rails', ">= 2.3")
    s.add_dependency('actionpack', ">= 2.3")
  end
end
