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
      preview = attachment(attachment_url) if attachment_url.present?

      content + content_tag(:div, preview, data: { list_remove: '' }, class: 'attachments')
    end

    def final_attribute_name
      record = object.is_a?(::ActiveRecord::Base)
      suffix = attribute_name.to_s.ends_with?('_id')

      if record and !suffix
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

    def attachment_record
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

      medium
    end

    def attachment_url
      attachment_record.try(:file_url, :preview) ||
      attachment_record.try(:file_url)
    end

    def attachment_name
      attachment_record.try(:name) ||
      attachment_record.try(:title)
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
      preview = image + video + file_preview

      if file_url.present?
        preview    = file_preview
        media_type = MiniMime.lookup_by_filename(file_url.split('/').last.to_s)
        media_type = media_type.content_type.split('/').first unless media_type.nil?

        case media_type
        when 'image'
          preview = image
        when 'video'
          preview = video
        end
      end

      content_tag :div, preview, class: 'margin-bottom-1', data: dataset
    end

    def file_preview
      span = content_tag :span, attachment_name, class: 'margin-bottom-1', data: { text: 'name' }
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
