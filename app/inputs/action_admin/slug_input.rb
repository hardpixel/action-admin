module ActionAdmin
  class SlugInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options)
      input_html_options[:placeholder] ||= raw_label_text
      input_html_options[:type]        ||= 'text'
      input_html_options[:class]       ||= []
      input_html_options[:class]        += ['small', 'edit-input']

      opts = { class: 'inline-edit-box', data: { inline_edit_box: '' } }

      template.content_tag(:div, opts) do
        template.concat preview_link
        template.concat super
        template.concat edit_button
        template.concat save_button
      end
    end

    def url
      method = options.fetch :url, ActionAdmin.config.app_urls
      template.try(method, object) unless object.new_record?
    end

    def prefix(text)
      "#{raw_label_text}: #{text}"
    end

    def input_value
      object.try(attribute_name)
    end

    def empty_value
      prefix('Not defined')
    end

    def value_pattern
      prefix "#{url}".sub("#{input_value}", '[val]')
    end

    def preview_value
      input_value.present? ? prefix(url) : empty_value
    end

    def preview_link
      data = { preview: '', value: value_pattern, placeholder: empty_value }
      template.content_tag :small, preview_value, class: 'edit-preview', data: data
    end

    def edit_button
      opts = { class: 'edit-button mdi mdi-pencil', data: { edit: '' } }
      template.content_tag :span, nil, opts
    end

    def save_button
      opts = { class: 'save-button mdi mdi-check', data: { save: '' } }
      template.content_tag :span, nil, opts
    end

    def label(wrapper_options)
      ''
    end
  end
end
