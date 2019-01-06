module ActionAdmin
  class AddMoreInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      html = content_tag :div, input_placeholder + remove_input, id: input_html_id, data: { add_more: '' }
      html + input_template
    end

    def hidden_input
      input_options = input_html_options

      input_options[:data]        ||= {}
      input_options[:data][:value]  = :id

      @builder.hidden_field(reflection_or_attribute_name, input_options)
    end

    def input_html_id
      hidden_input[/id=\"(.*)\"/, 1].dasherize
    end

    def remove_input
      if object.respond_to?("remove_#{reflection_or_attribute_name}")
        @builder.check_box("remove_#{reflection_or_attribute_name}", class: 'hide', data: { remove_input: '' })
      else
        ''.html_safe
      end
    end

    def input_placeholder
      span    = content_tag :span, 'No items available', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-playlist-plus'
      clear   = content_tag :a, 'Clear', data: { clear: "#{input_html_id}-preview" }, class: 'button alert hollow margin-0'
      clear   = content_tag :div, clear, class: 'cell auto'
      add     = content_tag :a, 'Add item', data: { add: input_html_id }, class: 'button success hollow margin-0'
      add     = content_tag :div, add, class: 'cell shrink'
      buttons = content_tag :div, clear + add, class: 'grid-x'
      content = content_tag :div, icon + span, class: 'no-content hide', data: { empty_state: '' }
      items   = list_items(attr_values) if attr_values.present?
      grid    = content_tag(:div, items, data: { list_remove: '' }, class: 'item-list', id: "#{input_html_id}-preview")

      content + grid + content_tag(:div, buttons, class: 'panel-section expanded border last')
    end

    def attr_values
      object.try(reflection_or_attribute_name)
    end

    def list_items(rows = [])
      fields = []

      @builder.fields_for reflection_or_attribute_name, rows do |f|
        row = item_fields.map do |attr_name, attr_options|
          attr_options[:class] ||= 'cell shrink'
          attr_options[:class]   = "#{attr_options[:class]} cell" unless 'cell'.in? attr_options[:class]

          f.input_field(attr_name, attr_options.merge(id: nil))
        end

        fields << list_item(row.join.html_safe)
      end

      fields.join.html_safe
    end

    def list_item(fields_html = nil)
      counter = content_tag :span, nil, class: 'counter'
      remove  = content_tag :span, nil, class: 'remove mdi mdi-close', data: { remove: '' }
      content = content_tag :div, fields_html, class: 'content grid-x'

      content_tag :div, counter + content + remove, data: { list_item: '' }, class: 'item'
    end

    def item_fields
      default = reflection.klass.attribute_names.reject { |v| v.in? ['id'] }.map(&:to_sym)
      options.fetch :fields, Hash[default.map { |k| [k, {}] }]
    end

    def input_template
      content_tag :template, list_items([reflection.klass.new]), id: "#{input_html_id}-item-template"
    end

    def label(wrapper_options)
      ''
    end
  end
end
