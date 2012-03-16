module MassassignmentSecurityForm
  module Extensions
    module FormTagHelper
      def self.included(base)
        base.class_eval do 
          alias_method_chain :form_tag, :massassignment_security
          alias_method_chain :form_for, :massassignment_security
        end
      end

      def form_tag_with_massassignment_security(*args, &block)
        if block_given?
          _init_form_fields

          if block.arity >= 1
            form_tag_without_massassignment_security(*args) do |f|
              yield(f)
              create_hidden_field_for_form_fields
            end
          else
            form_tag_without_massassignment_security(*args) do
              yield
              create_hidden_field_for_form_fields
            end
          end
          
          _clear_form_fields
        else
          form_tag_without_massassignment_security(*args)
        end
      end


      def form_for_with_massassignment_security(*args, &block)
        _init_form_fields
        
        form_for_without_massassignment_security(*args) do |f|
          yield(f)
          create_hidden_field_for_form_fields
        end

        _clear_form_fields
      end

      private
      def create_hidden_field_for_form_fields
#        if hashed_content = _generate_form_fields_hash
          concat(tag :input, :value => _generate_form_fields_hash, 
            :name => MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME, :type => 'hidden')
#        end
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
  end
end
