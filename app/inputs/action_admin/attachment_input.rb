module ActionAdmin
  class AttachmentInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options)
      modal = options.fetch :modal, 'media-modal'
      html  = content_tag :div, input_placeholder, id: input_html_id, data: { media_attach: modal }

      html + input_template
    end

    def input_placeholder
      span    = content_tag :span, 'No thumbnail', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-camera-off'
      button  = content_tag :a, 'Add Thumbnail', data: { open: input_html_id }, class: 'button success small hollow margin-0'
      content = content_tag :div, empty_input + icon + span + button, class: 'no-content hide', data: { empty_state: '' }
      image   = attachment(attachment_url) if attachment_url.present?

      content + content_tag(:div, image, data: { list_remove: '' }, class: 'attachments')
    end

    def empty_input
      @builder.hidden_field(:"#{attribute_name}_id", value: '', id: nil)
    end

    def hidden_input
      @builder.hidden_field(:"#{attribute_name}_id", data: { value: :id })
    end

    def input_html_id
      hidden_input[/id=\"(.*)\"/, 1].dasherize
    end

    def attachment_url
      object.send(attribute_name).try(:file_url, :preview)
    end

    def attachment(image_url=nil)
      image  = content_tag :img, nil, src: image_url, class: 'width-100 margin-bottom-1', data: { src: :id, url: "#{template.root_url.chomp('/')}[src]" }
      button = content_tag :a, 'Remove Thumbnail', class: 'button alert small hollow margin-0', data: { remove: '' }

      content_tag :div, hidden_input + image + button, class: 'attachment text-center', data: { list_item: '' }
    end

    def input_template
      content_tag :script, attachment, id: "#{input_html_id}-item-template", type: 'text/template'
    end

    def label(wrapper_options)
      ''
    end
  end
end
