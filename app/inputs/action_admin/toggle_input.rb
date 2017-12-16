module ActionAdmin
  class ToggleInput < SimpleForm::Inputs::BooleanInput
    def input(wrapper_options)
      @initial_label_text = raw_label_text

      input_html_options[:class] ||= []
      input_html_options[:class] << 'switch-input'

      options[:label_html] = { class: 'switch-paddle' }
      options[:label]      = content_tag :span, raw_label_text, class: 'show-for-sr'

      super
    end

    def label_input(wrapper_options)
      field_html = field_input(wrapper_options)

      template.content_tag :div, class: 'grid-x' do
        template.concat content_tag(:div, field_name, class: 'cell auto')
        template.concat content_tag(:div, field_html, class: 'cell shrink')
      end
    end

    def field_input(wrapper_options)
      content_tag :div, input(wrapper_options) + label(wrapper_options), class: 'switch tiny'
    end

    def field_name
      content_tag :label, @initial_label_text
    end

    def nested_boolean_style?
      false
    end
  end
end
