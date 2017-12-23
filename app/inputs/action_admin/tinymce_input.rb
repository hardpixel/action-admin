module ActionAdmin
  class TinymceInput < SimpleForm::Inputs::TextInput
    def input(wrapper_options)
      input_html_options[:data] ||= {}
      input_html_options[:data].merge!({
        tiny_mce_editor: '',
        content_css: template.asset_path('admin/tinymce-editor.css'),
        media_handler: 'media-modal',
        media_src: "file.large.url",
        media_alt: "name",
        media_url: "[src]",
        shortcode_handler: 'shortcode-modal',
        convert_urls: false
      })

      super
    end
  end
end
