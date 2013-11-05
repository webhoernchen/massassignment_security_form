# A sample Guardfile
# More info at https://github.com/guard/guard#readme

require 'guard/guard'

module ::Guard
  class InlineGuard < ::Guard::Guard
    def run_all
      good_or_bad = system "script/run_tests.sh"
      notify good_or_bad
    end

    def run_on_change(paths)
      paths = paths.select {|path| !path.include?('schema.rb')}
      unless paths.empty?
        good_or_bad = system "script/run_tests.sh"
        notify good_or_bad
      end
    end

    private
    def notify(good_or_bad)
      ::Guard::Notifier.notify(
        "Tests executed",
        :title => "Test::Unit results",
        :image => good_or_bad ? :success : :failed
      )
    end
  end
end

guard 'InlineGuard' do
  watch(%r{^lib/(.+)\.rb$})     { |m| m[0] }
  watch(%r{^test/(.+)\.rb$})     { |m| m[0] }
  watch(%r{^test_apps/(.+)\.rb$})     { |m| m[0] }
  watch(%r{^test_apps/(.+)\.erb$})     { |m| m[0] }
  watch(%r{^test_apps/(.+)\.yml$})     { |m| m[0] }
end
