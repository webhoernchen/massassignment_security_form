module MassassignmentSecurityForm
  module Extensions
    module Formtastic
      def self.included(base)
        base.class_eval do 
          alias_method_chain :generate_association_input_name, :massassignment_security_form
          alias_method_chain :boolean_input, :massassignment_security_form
          alias_method_chain :date_or_datetime_input, :massassignment_security_form
        end
      end

      def generate_association_input_name_with_massassignment_security_form(method)
        result = generate_association_input_name_without_massassignment_security_form(method)
        @template.send :_add_form_field, @object_name, result
        result
      end

      def boolean_input_with_massassignment_security_form(method, *args)
        @template.send :_add_form_field, @object_name, method
        boolean_input_without_massassignment_security_form(method, *args)
      end

      def date_or_datetime_input_with_massassignment_security_form(method, *args)
        @template.send :_add_form_field, @object_name, method
        date_or_datetime_input_without_massassignment_security_form(method, *args)
      end
    end
  end
end
