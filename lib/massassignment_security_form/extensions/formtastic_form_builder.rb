module MassassignmentSecurityForm
  module Extensions
    module FormtasticFormBuilder
      # Extend Formtatstic FormBuilder input method
      # Add _add_form_field method
      def input(name, *args)
        @template.send :_add_form_field, @object_name, name
        super
      end
    end
  end
end
  
begin
  require 'formtastic'
  if defined?(::Formtastic::SemanticFormBuilder)
    Formtastic::SemanticFormBuilder.send :prepare, MassassignmentSecurityForm::Extensions::FormtasticFormBuilder
  end
  if defined?(::Formtastic::FormBuilder)
    Formtastic::FormBuilder.send :prepare, MassassignmentSecurityForm::Extensions::FormtasticFormBuilder
  end
rescue Exception
end
