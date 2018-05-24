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
        @builder.check_box("remove_#{attribute_name}", class: 'hide', data: { dz_remove_input: '' })
      else
        ''.html_safe
      end
    end

    def current_input(image_url)
      if object.respond_to?("current_#{attribute_name}")
        @builder.hidden_field("current_#{attribute_name}", multiple: true, value: image_url)
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
      attribute = object.send(attribute_name)

      if multiple?
        image_size = input_options.fetch :thumbnail_size, :small
        content = Array(attribute).map do |file|
          image_url = file.try(:url, image_size)
          image_path = file.try(:path)
          image_name = file.file.file.split('/').last
          attachment(image_url, image_name, image_path, true) if image_url.present?
        end

        content.reject(&:blank?).join.html_safe
      else
        image_size = input_options.fetch :thumbnail_size, :medium
        image_url = attribute.try(:url)
        attachment(image_url) if image_url.present?
      end
    end

    def attachment(*args)
      multiple? ? attachment_multiple(*args) : attachment_single(*args)
    end

    def attachment_single(image_url=nil)
      image = content_tag :img, nil, src: image_url, class: 'width-100 margin-bottom-1', data: { dz_thumbnail: '' }
      content_tag :div, cache_input + image + attachment_controls, class: 'text-center'
    end

    def attachment_multiple(image_url=nil, image_name=nil, image_path=nil, removable=false)
      image    = content_tag :img, nil, src: image_url, class: 'width-100 margin-bottom-1', data: { dz_thumbnail: '' }
      filename = content_tag :span, image_name, class: 'filename', data: { dz_name: '' }
      content  = image + filename

      if removable.present?
        remove  = content_tag :span, nil, class: 'remove-button mdi mdi-close', data: { remove: '' }
        content = content + remove + current_input(image_path)
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
  end
end
