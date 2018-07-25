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
      clear   = content_tag :a, 'Clear', data: { clear: "#{input_html_id}-preview" }, class: 'button alert hollow margin-0'
      clear   = content_tag :div, clear, class: 'cell auto'
      add     = content_tag :a, 'Add media', data: { open: input_html_id }, class: 'button success hollow margin-0'
      add     = content_tag :div, add, class: 'cell shrink'
      buttons = content_tag :div, clear + add, class: 'grid-x'
      content = content_tag :div, empty_input + icon + span, class: 'no-content hide', data: { empty_state: '' }
      images  = attachments(attachment_urls) if attachment_urls.present?
      grid    = content_tag(:div, images, data: { list_remove: '' }, class: 'attachments-grid removable')

      content + grid + content_tag(:div, buttons, class: 'panel-section expanded border last')
    end

    def final_attribute_name
      record = object.is_a?(::ActiveRecord::Base)
      suffix = attribute_name.to_s.ends_with?('_ids')

      if record and !suffix
        :"#{attribute_name.to_s.singularize}_ids"
      else
        :"#{attribute_name}"
      end
    end

    def empty_input
      @builder.hidden_field(final_attribute_name, value: '', id: nil, multiple: true)
    end

    def hidden_input(file_id=nil)
      input_options = input_html_options

      input_options[:data]        ||= {}
      input_options[:data][:value]  = :id

      @builder.hidden_field(final_attribute_name, input_options.merge(multiple: true, value: file_id))
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

      Array(media).map { |a| [a.try(:id), a.try(:file_url, :small) || a.try(:file_url), a.try(:name)] }
    end

    def attachments(urls=[])
      urls.map { |u| attachment(*u) }.join.html_safe
    end

    def attachment(file_id=nil, file_url=nil, file_name=nil)
      dataset  = { src: 'file.small.url', src_alt: 'file.url', url: "#{template.root_url.chomp('/')}[src]" }
      filename = content_tag :span, file_name, class: 'filename', data: { text: 'name' }
      remove   = content_tag :span, nil, class: 'remove-button mdi mdi-close', data: { remove: '' }
      thumb    = content_tag :div, attachment_preview(file_url) + filename + remove, class: 'thumbnail', data: dataset

      content_tag :div, hidden_input(file_id) + thumb, class: 'attachment', data: { list_item: '' }
    end

    def attachment_preview(file_url=nil)
      image   = content_tag :img, nil, src: file_url || image_url('upload'), data: { mime_match: 'image/*', replace: 'src' }
      video   = content_tag :img, nil, src: image_url('video'), data: { mime_match: 'video/*' }
      file    = content_tag :img, nil, src: image_url('file'), data: { mime_match: '*/*' }
      preview = image + video + file

      if file_url.present?
        preview    = file
        media_type = MiniMime.lookup_by_filename(file_url.split('/').last.to_s)
        media_type = media_type.content_type.split('/').first unless media_type.nil?

        case media_type
        when 'image'
          preview = image
        when 'video'
          preview = video
        end
      end

      preview
    end

    def input_template
      content_tag :template, attachment, id: "#{input_html_id}-item-template"
    end

    def label(wrapper_options)
      ''
    end

    def image_url(type)
      template.asset_url("admin/#{type}-preview.svg")
    end
  end
end
