module ActionAdmin
  class TinymceInput < SimpleForm::Inputs::TextInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({ tiny_mce_editor: '' })
      super
    end
  end
end
