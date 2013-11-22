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
  require "massassignment_security_form/extensions/formtastic"
  require "massassignment_security_form/massassignment_columns_hash"

  ActionView::Base.send(:include, MassassignmentSecurityForm::Extensions::FormHelper)
  ActionController::Base.send(:include, MassassignmentSecurityForm::Extensions::Controller)
  
  begin
    require 'formtastic'
    if defined?(::Formtastic)
      Formtastic::SemanticFormBuilder.send(:include, MassassignmentSecurityForm::Extensions::Formtastic)
    end
  rescue Exception => e
  end
rescue Exception => e
  p e.message
  p 'Could not init massassignment_security_form'
end
