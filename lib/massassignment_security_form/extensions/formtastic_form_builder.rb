module MassassignmentSecurityForm
  module Extensions
    module FormtasticFormBuilder
      def self.included(base)
        base.class_eval do 
          alias_method_chain :input, :massassignment_security_form
        end
      end

      # Extend Formtatstic FormBuilder input method
      # Add _add_form_field method
      def input_with_massassignment_security_form(name, *args)
        @template.send :_add_form_field, @object_name, name
        input_without_massassignment_security_form name, *args
      end
    end
  end
end
  
begin
  require 'formtastic'
  if defined?(::Formtastic::SemanticFormBuilder)
    Formtastic::SemanticFormBuilder.send(:include, MassassignmentSecurityForm::Extensions::FormtasticFormBuilder)
  end
  if defined?(::Formtastic::FormBuilder)
    Formtastic::FormBuilder.send(:include, MassassignmentSecurityForm::Extensions::FormtasticFormBuilder)
  end
rescue Exception => e
end
