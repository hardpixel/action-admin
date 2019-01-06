module ActionAdmin
  module Form
    class Builder < ::SimpleForm::FormBuilder
      # Initialize form builder
      def initialize(*)
        super

        @admin = {
          button_class:             'button',
          error_notification_class: 'callout alert',
          default_wrapper:          :admin_vertical_form,
          wrapper_mappings:         {
            check_boxes:   :admin_horizontal_radio_and_checkboxes,
            radio_buttons: :admin_horizontal_radio_and_checkboxes,
            # boolean:       :admin_horizontal_radio_and_checkboxes,
            datetime:      :admin_horizontal_multi_select,
            date:          :admin_horizontal_multi_select,
            time:          :admin_horizontal_multi_select,
            # file:          :admin_horizontal_file_input
          }
        }

        @wrapper = ::SimpleForm.wrapper(options[:wrapper] || @admin[:default_wrapper])
      end

      # Create form button
      def button(type, *args, &block)
        options = args.extract_options!.dup
        options[:class] = [@admin[:button_class], options[:class]].compact
        args << options
        if respond_to?(:"#{type}_button")
          send(:"#{type}_button", *args, &block)
        else
          send(type, *args, &block)
        end
      end

      # Create error notification
      def error_notification(options = {})
        Form::ErrorNotification.new(self, options).render
      end

      # Find field wrapper
      def find_wrapper_mapping(input_type)
        if options[:wrapper_mappings] && options[:wrapper_mappings][input_type]
          options[:wrapper_mappings][input_type]
        else
          @admin[:wrapper_mappings] && @admin[:wrapper_mappings][input_type]
        end
      end

      # Find namespaced input
      def attempt_mapping_with_custom_namespace(input_name)
        ['ActionAdmin', 'Admin'].each do |namespace|
          if (mapping = attempt_mapping(input_name, namespace.constantize))
            return mapping
          end
        end

        nil
      end
    end
  end
end
