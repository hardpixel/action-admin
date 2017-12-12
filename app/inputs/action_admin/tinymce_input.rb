module ActionAdmin
  class TinymceInput < SimpleForm::Inputs::TextInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({ tiny_mce_editor: '', content_css: template.asset_path('admin/tinymce-editor.css') })
      super
    end
  end
end
