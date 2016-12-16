module MassassignmentSecurityForm
  module Extensions
    module FormTagHelper
      def self.included(base)
        base.class_eval do 
          alias_method_chain :form_tag, :massassignment_security
          alias_method_chain :form_for, :massassignment_security
        end
      end

      private
      def create_hidden_field_for_form_fields
        tag :input, :value => _generate_form_fields_hash, 
          :name => MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME, :type => 'hidden'
      end

      def _init_form_fields
        @_form_fields = MassassignmentSecurityForm::MassassignmentColumnsHash.new
      end

      def _form_fields
        @_form_fields
      end
      
      def _add_form_field(object_name, method)
        if @_nested_form_field
          parent_object_name, nested, many_reflection = @_nested_form_field
          _form_fields && _form_fields.add_nested_column(parent_object_name, nested, many_reflection, method)
        else
          _form_fields && _form_fields.add_column(object_name, method)
        end
      end
      
      def _clear_form_fields
        @_form_fields = nil
      end

      def _generate_form_fields_hash
        _form_fields.to_encrypted_string
      end

      def _init_nested_form_field_for_key(key)
        @_nested_form_field = key
      end

      def _clear_nested_form_field_for_key
        @_nested_form_field = nil
      end
      
      def form_tag(*form_args, &block)
        if block_given? && @_form_fields.nil?
          _init_form_fields

          html = super *form_args do |*args|
            capture(*args, &block).to_s.html_safe << create_hidden_field_for_form_fields.html_safe
          end
          
          _clear_form_fields
          
          html
        else
          super
        end
      end

      def form_for(*args, &block)
        _init_form_fields
        
        html = super *args do |f|
          capture(f, &block).to_s.html_safe << create_hidden_field_for_form_fields.html_safe
        end

        _clear_form_fields

        html
      end
    end
  end
end

ActionView::Base.send :prepend, MassassignmentSecurityForm::Extensions::FormTagHelper
