module ActionAdmin
  class AttachmentsInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      modal = options.fetch :modal, 'media-modal'
      html  = content_tag :div, input_placeholder, id: input_html_id, data: { media_attach: modal, media_multiple: true }

      html + input_template
    end

    def input_placeholder
      span    = content_tag :span, 'No media attached', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-camera-off'
      button  = content_tag :a, 'Add media', data: { open: input_html_id }, class: 'button success small hollow margin-0'
      content = content_tag :div, empty_input + icon + span, class: 'no-content hide', data: { empty_state: '' }
      images  = attachments(attachment_urls) if attachment_urls.present?
      grid    = content_tag(:div, images, data: { list_remove: '' }, class: 'attachments-grid removable')

      content + grid + content_tag(:div, button, class: 'panel-section expanded border last')
    end

    def final_attribute_name
      if object.is_a? ::ActiveRecord::Base
        :"#{attribute_name}_ids"
      else
        :"#{attribute_name}"
      end
    end

    def empty_input
      @builder.hidden_field(final_attribute_name, value: '', id: nil, multiple: true)
    end

    def hidden_input(image_id=nil)
      input_options = input_html_options

      input_options[:data]        ||= {}
      input_options[:data][:value]  = :id

      @builder.hidden_field(final_attribute_name, input_options.merge(multiple: true, value: image_id))
    end

    def input_html_id
      hidden_input[/id=\"(.*)\"/, 1].dasherize
    end

    def attachment_urls
      media = nil

      if object.is_a? ::ActiveRecord::Base
        media = object.try(attribute_name)
      elsif options[:model_name]
        media_model = "#{options[:model_name]}".safe_constantize

        if media_model.present?
          attval = object.send(attribute_name) rescue nil
          media = media_model.where(id: attval)
        end
      end

      Array(media).map { |a| [a.try(:id), a.try(:file_url, :small), a.try(:name)] }
    end

    def attachments(urls=[])
      urls.map { |u| attachment(*u) }.join.html_safe
    end

    def attachment(image_id=nil, image_url=nil, image_name=nil)
      image    = content_tag :img, nil, src: image_url, class: 'width-100 margin-bottom-1', data: { src: 'file.small.url', src_fallback: 'file.url', url: "#{template.root_url.chomp('/')}[src]" }
      filename = content_tag :span, image_name, class: 'filename', data: { text: 'name' }
      remove   = content_tag :span, nil, class: 'remove-button mdi mdi-close', data: { remove: '' }
      thumb    = content_tag :div, image + filename + remove, class: 'thumbnail'

      content_tag :div, hidden_input(image_id) + thumb, class: 'attachment', data: { list_item: '' }
    end

    def input_template
      content_tag :template, attachment, id: "#{input_html_id}-item-template"
    end

    def label(wrapper_options)
      ''
    end
  end
end
