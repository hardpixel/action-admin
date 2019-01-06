module ActionAdmin
  class ScheduleInput < SimpleForm::Inputs::Base
    def input(wrapper_options)
      html = content_tag :div, hidden_input + input_placeholder, id: input_html_id, data: { rrule_schedule: 'schedule-modal' }
      html + input_template
    end

    def hidden_input
      input_options = input_html_options
      @builder.hidden_field(reflection_or_attribute_name, input_options.merge(value: '', multiple: true))
    end

    def input_html_id
      hidden_input[/id=\"(.*)\"/, 1].dasherize
    end

    def input_placeholder
      span    = content_tag :span, 'No schedules available', class: 'margin-bottom-1'
      icon    = content_tag :i, nil, class: 'mdi mdi-calendar-clock'
      clear   = content_tag :a, 'Clear', data: { clear: "#{input_html_id}-preview" }, class: 'button alert hollow margin-0'
      clear   = content_tag :div, clear, class: 'cell auto'
      add     = content_tag :a, 'Add rule', data: { open: input_html_id }, class: 'button success hollow margin-0'
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
      fields = Array(rows).map { |i| list_item(i) }
      fields.join.html_safe
    end

    def list_item(value = nil)
      counter   = content_tag :span, nil, class: 'counter'
      remove    = content_tag :span, nil, class: 'remove mdi mdi-close', data: { remove: '' }
      item_html = content_tag :span, value, class: 'form-element', data: { rrule_string: '' }
      item_inp  = @builder.hidden_field(reflection_or_attribute_name, value: value, multiple: true, id: nil, data: { rrule_input: '' })
      content   = content_tag :div, item_html + item_inp, class: 'content grid-x'
      dataset   = { list_item: '', rrule_string: value }

      content_tag :div, counter + content + remove, title: value, data: dataset, class: 'item'
    end

    def input_template
      content_tag :template, list_item, id: "#{input_html_id}-item-template"
    end

    def label(wrapper_options)
      ''
    end
  end
end
