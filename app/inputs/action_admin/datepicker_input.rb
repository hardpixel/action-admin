module ActionAdmin
  class DatepickerInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!(date_picker: '')

      input_html_options[:class] ||= []
      input_html_options[:class]  += ['datepicker']

      super
    end
  end
end
