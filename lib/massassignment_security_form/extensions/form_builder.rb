module MassassignmentSecurityForm
  module Extensions
    module FormBuilder
      def fields_for(name, *args, &block)
        key = if nested_attributes_association? name
          "#{name}_attributes".to_sym
        else
          name.to_sym
        end

        many_reflection = if reflection = object.class.reflect_on_association(name)
          reflection.collection?
        else
          false
        end
       
        @template.send :_init_nested_form_field_for_key, [object_name, key, many_reflection]
        super
      ensure
        @template.send :_clear_nested_form_field_for_key
      end
    end
  end
end

ActionView::Helpers::FormBuilder.send :prepend, MassassignmentSecurityForm::Extensions::FormBuilder
