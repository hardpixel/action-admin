module ActionAdmin
  class AttachmentInput < SimpleForm::Inputs::Base
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

    def final_attribute_name
      if object.is_a? ::ActiveRecord::Base
        :"#{attribute_name}_id"
      else
        :"#{attribute_name}"
      end
    end

    def empty_input
      @builder.hidden_field(final_attribute_name, value: '', id: nil)
    end

    def hidden_input
      input_options = input_html_options

      input_options[:data]        ||= {}
      input_options[:data][:value]  = :id

      @builder.hidden_field(final_attribute_name, input_options)
    end

    def input_html_id
      hidden_input[/id=\"(.*)\"/, 1].dasherize
    end

    def attachment_url
      object.try(attribute_name).try(:file_url, :preview)
    end

    def attachment(image_url=nil)
      image   = content_tag :img, nil, src: image_url, class: 'width-100 margin-bottom-1', data: { src: 'file.preview.url', url: "#{template.root_url.chomp('/')}[src]" }
      remove  = content_tag :a, 'Remove', class: 'button alert small hollow margin-0', data: { remove: '' }
      change  = content_tag :a, 'Change', class: 'button success small hollow margin-0', data: { open: input_html_id }
      remove  = content_tag :div, remove, class: 'cell auto text-left'
      change  = content_tag :div, change, class: 'cell shrink'
      buttons = content_tag :div, remove + change, class: 'panel-section expanded border last grid-x'

      content_tag :div, hidden_input + image + buttons, class: 'attachment text-center', data: { list_item: '' }
    end

    def input_template
      content_tag :script, attachment, id: "#{input_html_id}-item-template", type: 'text/template'
    end

    def label(wrapper_options)
      ''
    end
  end
end
