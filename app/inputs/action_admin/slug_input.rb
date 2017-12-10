module ActionAdmin
  class SlugInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options)
      input_html_options[:placeholder] ||= raw_label_text
      input_html_options[:type]        ||= 'text'
      input_html_options[:class]       ||= []
      input_html_options[:class]        += ['small', 'edit-input']

      wrapper_options = { class: 'inline-edit-box', data: { inline_edit_box: '' } }

      template.content_tag(:div, wrapper_options) do
        template.concat preview_link
        template.concat super
        template.concat edit_button
        template.concat save_button
      end
    end

    def url
      template.send(options[:url], input_value)
    end

    def input_value
      object.try(attribute_name)
    end

    def value_pattern
      "#{url}".sub("#{input_value}", '[val]')
    end

    def preview_value
      input_value.present? ? url : 'Not defined'
    end

    def preview_text
      "#{raw_label_text}: #{preview_value}"
    end

    def preview_link
      data = { preview: '', value: value_pattern, placeholder: "#{raw_label_text}: Not defined" }
      template.link_to preview_text, url, target: :_blank, class: 'edit-preview', data: data
    end

    def edit_button
      opts = { class: 'edit-button mdi mdi-pencil', data: { edit: '' } }
      template.content_tag :span, nil, opts
    end

    def save_button
      opts = { class: 'save-button mdi mdi-check', data: { save: '' } }
      template.content_tag :span, nil, opts
    end

    def label
      ''
    end
  end
end
