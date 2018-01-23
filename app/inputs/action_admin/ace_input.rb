module ActionAdmin
  class AceInput < SimpleForm::Inputs::TextInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({ ace_editor: '', base_path: '/assets/admin/ace' })

      super
    end
  end
end
