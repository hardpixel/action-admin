module ActionAdmin
  class TitleInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options)
      input_html_options[:placeholder] ||= raw_label_text
      input_html_options[:type]        ||= 'text'
      input_html_options[:class]       ||= []
      input_html_options[:class]        += ['large']

      super
    end

    def label(wrapper_options)
      ''
    end
  end
end
