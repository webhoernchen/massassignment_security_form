module MassassignmentSecurityForm
  module Extensions
    module Controller
      def self.included(base)
        method_name = :remove_not_allowed_massassignment_fields_from_params
        
        # fix DEPRECATION WARNING:
        # before_filter is deprecated and will be removed in Rails 5.1. Use before_action instead
        base.class_eval do
          if respond_to? :before_action
            before_action method_name
          else
            before_filter method_name
          end
        end
      end

      private
      def remove_not_allowed_massassignment_fields_from_params
        if allow_removing_massassignment_fields_from_params
          if allow_fields_encrypted = params[MassassignmentSecurityForm::Config::MASSASSIGNMENT_PARAMS_NAME]
            allowed_columns = MassassignmentSecurityForm::MassassignmentColumnsHash.parse_from(allow_fields_encrypted) 
            allowed_columns.remove_not_allowed_massassignments_from(params)
          else
            remove_all_massassignemnts_from_params
          end
        end
        
        params.respond_to?(:permit!) && params.permit!
        
        true
      end

      def remove_all_massassignemnts_from_params
        params.each do |key, value| 
          if value.is_a?(Hash)
            value.clear
          end
        end
      end

      # Für ActiveScaffold ist diese Aktion nicht nötig
      def allow_removing_massassignment_fields_from_params
        if self.class.respond_to?(:uses_active_scaffold?) && self.class.uses_active_scaffold?
          false
        else
          MassassignmentSecurityForm::Config.remove_not_allowed_massassignment_fields
        end
      end
    end
  end
end
