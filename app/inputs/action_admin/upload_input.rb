module ActionAdmin
  class UploadInput < SimpleForm::Inputs::FileInput
    def input(wrapper_options)
      out  = ActiveSupport::SafeBuffer.new
      data = { file_input: '', previews_container: "##{input_html_id}-preview" }
      data = data.merge(thumbnail_width: 400, thumbnail_height: 400) if multiple?
      html = content_tag :div, input_placeholder + remove_input, id: input_html_id, class: 'dropzone', data: data

      out << html
      out << input_template
    end

    def input_placeholder
      multiple? ? input_placeholder_multiple + attachment_controls : input_placeholder_single
    end

    def input_placeholder_single
      span    = content_tag :span, 'Drop file here', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-upload'
      button  = content_tag :label, 'Upload File', for: attr_html_id, class: 'button success small hollow margin-0'
      content = content_tag :div, icon + span + file_input + button, class: 'no-content'

      content_tag(:div, content, class: 'dz-message bordered hide') +
      content_tag(:div, existing_attachments, id: "#{input_html_id}-preview")
    end

    def input_placeholder_multiple
      span    = content_tag :span, 'Drop files here to upload', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-upload'
      button  = content_tag :label, 'Select Files', for: attr_html_id, class: 'button success hollow margin-top-1'
      content = content_tag :div, icon + span + file_input + button, class: 'no-content'

      current_input('') +
      content_tag(:div, content, class: 'dz-message bordered hide') +
      content_tag(:div, existing_attachments, id: "#{input_html_id}-preview", class: 'attachments-grid removable', data: { list_remove: '' } )
    end

    def file_input
      @builder.file_field(attribute_name, input_html_options)
    end

    def cache_input
      if object.respond_to?("#{attribute_name}_cache")
        @builder.hidden_field("#{attribute_name}_cache")
      else
        ''.html_safe
      end
    end

    def remove_input
      if object.respond_to?("remove_#{attribute_name}")
        checkbox_options = { class: 'hide', data: { dz_remove_input: '' } }
        @builder.check_box("remove_#{attribute_name}", checkbox_options, true, false)
      else
        ''.html_safe
      end
    end

    def current_input(file_url)
      if object.respond_to?("current_#{attribute_name}")
        @builder.hidden_field("current_#{attribute_name}", multiple: true, value: file_url)
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

    def existing_attachments
      attribute  = object.send(attribute_name)
      thumb_size = input_options.fetch :thumbnail_size, :small

      if multiple?
        content = Array(attribute).map do |file|
          file_url  = file.try(:url, thumb_size) || file.try(:url)
          file_path = file.try(:path)
          file_name = file.file.file.split('/').last

          attachment(file_url, file_name, file_path, true) if file_url.present?
        end

        content.reject(&:blank?).join.html_safe
      else
        file_url  = attribute.try(:url)
        file_name = file_url.to_s.split('/').last

        attachment(file_url, file_name) if file_url.present?
      end
    end

    def attachment(*args)
      media_type = MiniMime.lookup_by_filename(args.first.to_s)
      media_type = media_type.content_type.split('/').first unless media_type.nil?

      multiple? ? attachment_multiple(*args, media_type) : attachment_single(*args, media_type)
    end

    def attachment_single(file_url=nil, file_name=nil, media_type=nil)
      image = content_tag :img, nil, src: file_url, data: { mime_match: 'image/*', dz_thumbnail: '' }
      video = content_tag :video, nil, src: file_url, controls: true, data: { mime_match: 'video/*', dz_video: '' }

      if media_type.nil?
        preview = image + video + file_preview(file_name)
      else
        case media_type
        when 'image'
          preview = image
        when 'video'
          preview = video
        else
          preview = file_preview(file_name)
        end
      end

      preview = content_tag :div, preview, class: 'margin-bottom-1'
      content_tag :div, cache_input + preview + attachment_controls, class: 'text-center'
    end

    def attachment_multiple(file_url=nil, file_name=nil, file_path=nil, removable=false, media_type=nil)
      image = content_tag :img, nil, src: file_url || image_url('upload'), data: { mime_match: 'image/*', dz_thumbnail: '' }
      video = content_tag :img, nil, src: image_url('video'), data: { mime_match: 'video/*' }
      file  = content_tag :img, nil, src: image_url('file'), data: { mime_match: '*/*' }
      fname = content_tag :span, file_name, class: 'filename', data: { dz_name: '' }

      if media_type.nil?
        content = image + video + file
      else
        case media_type
        when 'image'
          content = image
        when 'video'
          content = video
        else
          content = file
        end
      end

      content = content + fname

      if removable.present?
        remove  = content_tag :span, nil, class: 'remove-button mdi mdi-close', data: { remove: '' }
        content = content + remove + current_input(file_path)
        classes = nil
      else
        size    = content_tag :span, nil, class: 'size left', data: { dz_size: '' }
        added   = content_tag :span, nil, class: 'new-button mdi mdi-plus'
        content = content + size + added
        classes = 'is-new'
      end

      thumb = content_tag :div, content, class: 'thumbnail'
      content_tag :div, thumb, class: "attachment #{classes}", data: { list_item: '' }
    end

    def file_preview(file_name=nil)
      span = content_tag :span, file_name, class: 'margin-bottom-1', data: { dz_name: '' }
      icon = content_tag :i, nil, class: 'mdi mdi-file-document-box'

      content_tag :div, icon + span, class: 'file-preview', data: { mime_match: '*/*' }
    end

    def input_template
      content_tag :template, attachment, id: "#{input_html_id}-preview-template"
    end

    def attachment_controls
      if multiple?
        rmtext = 'Clear'
        chtext = 'Add Files'
      else
        rmtext = 'Remove'
        chtext = 'Change'
      end

      btsize = 'small' unless multiple?
      remove = content_tag :a, rmtext, class: "button alert #{btsize} hollow margin-0", data: { dz_remove: '' }
      change = content_tag :a, chtext, class: "button success #{btsize} hollow margin-0", data: { dz_change: '' }
      remove = content_tag :div, remove, class: 'cell auto text-left'
      change = content_tag :div, change, class: 'cell shrink'

      content_tag :div, remove + change, class: 'panel-section expanded border last grid-x', data: { dz_controls: '' }
    end

    def label(wrapper_options)
      ''
    end

    private

      def multiple?
        input_html_options[:multiple] == true
      end

      def image_url(type)
        template.asset_url("admin/#{type}-preview.svg")
      end
  end
end
