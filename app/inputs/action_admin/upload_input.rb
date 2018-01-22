module ActionAdmin
  class UploadInput < SimpleForm::Inputs::FileInput
    def input(wrapper_options)
      out  = ActiveSupport::SafeBuffer.new
      data = { file_input: '', previews_container: "##{input_html_id}-preview" }
      html = content_tag :div, input_placeholder, id: input_html_id, class: 'dropzone', data: data

      out << html
      out << input_template
    end

    def input_placeholder
      span    = content_tag :span, 'Drop file here', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-upload'
      button  = content_tag :label, 'Upload File', for: attr_html_id, class: 'button success small hollow margin-0'
      content = content_tag :div, icon + span + file_input + button, class: 'no-content'
      image   = attachment(attachment_url) if attachment_url.present?

      content_tag(:div, content, class: 'dz-message bordered hide') +
      content_tag(:div, image, id: "#{input_html_id}-preview")
    end

    def file_input
      @builder.file_field(attribute_name, input_html_options)
    end

    def hidden_input
      if object.respond_to?("#{attribute_name}_cache")
        @builder.hidden_field("#{attribute_name}_cache")
      else
        ''.html_safe
      end
    end

    def attr_html_id
      file_input[/id=\"(.*)\"/, 1]
    end

    def input_html_id
      attr_html_id.dasherize
    end

    def attachment_url
      object.send(attribute_name).try(:url)
    end

    def attachment(image_url=nil)
      image   = content_tag :img, nil, src: image_url, class: 'width-100 margin-bottom-1', data: { dz_thumbnail: '' }
      remove  = content_tag :a, 'Remove', class: 'button alert small hollow margin-0', data: { dz_remove: '' }
      change  = content_tag :a, 'Change', class: 'button success small hollow margin-0', data: { dz_change: '' }
      remove  = content_tag :div, remove, class: 'cell auto text-left'
      change  = content_tag :div, change, class: 'cell shrink'
      buttons = content_tag :div, remove + change, class: 'panel-section expanded border last grid-x'

      content_tag :div, hidden_input + image + buttons, class: 'text-center'
    end

    def input_template
      content_tag :script, attachment, id: "#{input_html_id}-preview-template", type: 'text/template'
    end

    def label(wrapper_options)
      ''
    end
  end
end
