module MassassignmentSecurityForm
  module Extensions
    module FormHelper
      def text_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def password_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def hidden_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def file_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def text_area(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def check_box(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def radio_button(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def country_select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def collection_select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def grouped_collection_select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def date_select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def file_column_field(object_name, method, *args)
        _add_form_field(object_name, method)
        _add_form_field(object_name, method.to_s + '_temp')
        super(object_name, method, *args)
      end

      def select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def time_select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def datetime_select(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def search_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end
      
      def telephone_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end
      
      def phone_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end
      
      def url_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end
      
      def email_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def number_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end

      def range_field(object_name, method, *args)
        _add_form_field(object_name, method)
        super(object_name, method, *args)
      end
    end
  end
end
