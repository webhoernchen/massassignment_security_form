begin
  module MassassignmentSecurityForm
  end
 
  if Rails.version >= "3.0"
    require "massassignment_security_form/railtie"
  end

  require 'action_view'
  require 'action_view/base'
  require "massassignment_security_form/extensions/form_tag_helper"
  require "massassignment_security_form/extensions/form_helper"
  require "massassignment_security_form/extensions/controller"
  require "massassignment_security_form/extensions/formtastic_form_builder"
  require "massassignment_security_form/extensions/form_builder"
  require "massassignment_security_form/massassignment_columns_hash"

  ActionView::Base.send :prepend, MassassignmentSecurityForm::Extensions::FormHelper
  ActionController::Base.send :prepend, MassassignmentSecurityForm::Extensions::Controller
rescue Exception => e
  p e.message
  p 'Could not init massassignment_security_form'
end
