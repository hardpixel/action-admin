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
      button  = content_tag :a, 'Add Thumbnail', data: { open: input_html_id }, class: 'button success small hollow'
      content = content_tag :div, empty_input + icon + span + button, class: 'no-content panel-section expanded border first last hide', data: { empty_state: '' }
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
      medium = nil

      if object.is_a? ::ActiveRecord::Base
        medium = object.try(attribute_name)
      elsif options[:model_name]
        media_model = "#{options[:model_name]}".safe_constantize

        if media_model.present?
          attval = object.send(attribute_name) rescue nil
          medium = media_model.find_by_id(attval)
        end
      end

      medium.try(:file_url, :preview)
    end

    def attachment(file_url=nil)
      remove  = content_tag :a, 'Remove', class: 'button alert small hollow margin-0', data: { remove: '' }
      change  = content_tag :a, 'Change', class: 'button success small hollow margin-0', data: { open: input_html_id }
      remove  = content_tag :div, remove, class: 'cell auto text-left'
      change  = content_tag :div, change, class: 'cell shrink'
      buttons = content_tag :div, remove + change, class: 'panel-section expanded border last grid-x'

      content_tag :div, hidden_input + attachment_preview(file_url) + buttons, class: 'attachment text-center', data: { list_item: '' }
    end

    def attachment_preview(file_url=nil)
      dataset = { src: 'file.preview.url', src_alt: 'file.url', url: "#{template.root_url.chomp('/')}[src]" }
      image   = content_tag :img, nil, src: file_url, class: 'width-100', data: { mime_match: 'image/*', replace: 'src' }
      video   = content_tag :video, nil, src: file_url, class: 'width-100', controls: true, data: { mime_match: 'video/*', replace: 'src' }
      file    = file_preview(file_url)
      preview = image + video + file

      if file_url.present?
        media_type = MiniMime.lookup_by_filename(file_url.split('/').last.to_s)
        media_type = media_type.content_type.split('/').first unless media_type.nil?

        case media_type
        when 'image'
          preview = image
        when 'video'
          preview = video
        else
          preview = file
        end
      end

      content_tag :div, preview, class: 'margin-bottom-1', data: dataset
    end

    def file_preview(file_url=nil)
      span = content_tag :span, "#{file_url}".split('/').last, class: 'margin-bottom-1', data: { text: 'name' }
      icon = content_tag :i, nil, class: 'mdi mdi-file-document-box'

      content_tag :div, icon + span, class: 'no-content preview-file', data: { mime_match: '*/*' }
    end

    def input_template
      content_tag :template, attachment, id: "#{input_html_id}-item-template"
    end

    def label(wrapper_options)
      ''
    end
  end
end
