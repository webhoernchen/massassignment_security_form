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
        @_form_fields ||= MassassignmentSecurityForm::MassassignmentColumnsHash.new
      end
      
      def _add_form_field(object_name, method)
        _form_fields.add_column(object_name, method)
      end
      
      def _clear_form_fields
        @_form_fields = nil
      end

      def _generate_form_fields_hash
        _form_fields.to_encrypted_string
      end
    end

    module FormTagHelperRails23
      def form_tag_with_massassignment_security(*form_args, &block)
        if block_given?
          _init_form_fields

          form_tag_without_massassignment_security(*form_args) do |*args|
            yield(*args)
            concat create_hidden_field_for_form_fields
          end
          
          _clear_form_fields
        else
          form_tag_without_massassignment_security(*form_args)
        end
      end

      def form_for_with_massassignment_security(*args, &block)
        _init_form_fields
        
        form_for_without_massassignment_security(*args) do |f|
          yield(f)
          concat create_hidden_field_for_form_fields
        end

        _clear_form_fields
      end
    end

    module FormTagHelperRails3
      def form_tag_with_massassignment_security(*form_args, &block)
        if block_given?
          _init_form_fields

          html = form_tag_without_massassignment_security(*form_args) do |*args|
            capture(*args, &block).to_s.html_safe << create_hidden_field_for_form_fields.html_safe
          end
          
          _clear_form_fields
          
          html
        else
          form_tag_without_massassignment_security(*form_args)
        end
      end

      def form_for_with_massassignment_security(*args, &block)
        _init_form_fields
        
        html = form_for_without_massassignment_security(*args) do |f|
          capture(f, &block).to_s.html_safe << create_hidden_field_for_form_fields.html_safe
        end

        _clear_form_fields

        html
      end
    end
  end
end

ActionView::Base.send(:include, MassassignmentSecurityForm::Extensions::FormTagHelperRails23) if Rails.version < '3.0'
ActionView::Base.send(:include, MassassignmentSecurityForm::Extensions::FormTagHelperRails3) if Rails.version >= '3.0' 
ActionView::Base.send(:include, MassassignmentSecurityForm::Extensions::FormTagHelper)
