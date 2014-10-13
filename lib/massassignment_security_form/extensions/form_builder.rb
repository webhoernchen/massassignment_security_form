module MassassignmentSecurityForm
  module Extensions
    module FormBuilder
      def self.included(base)
        base.class_eval do 
          alias_method_chain :fields_for, :massassignment_security_form
        end
      end

      def fields_for_with_massassignment_security_form(name, *args, &block)
        key = if nested_attributes_association? name
          "#{name}_attributes".to_sym
        else
          name.to_sym
        end

        one_or_many_reflection = if reflection = object.class.reflect_on_association(name)
          if [:has_many, :has_and_belongs_to_many].include?(reflection.macro)
            :many
          else
            :one
          end
        else
          :one
        end
       
        @template.send :_init_nested_form_field_for_key, [object_name, key, one_or_many_reflection]
        fields_for_without_massassignment_security_form name, *args, &block
      ensure
        @template.send :_clear_nested_form_field_for_key
      end
    end
  end
end

ActionView::Helpers::FormBuilder.send :include, MassassignmentSecurityForm::Extensions::FormBuilder
