module ActionAdmin
  class TextareaInput < SimpleForm::Inputs::TextInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({ textarea: '' })

      super
    end
  end
end
