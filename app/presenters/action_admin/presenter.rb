module ActionAdmin
  class Presenter
    include ActionAdmin::Presentable

    def initialize(record, context)
      @model   = record.class
      @record  = record
      @context = context
    end

    def attributes
      self.record_attributes
    end

    def attribute_names
      if attributes.keys.any?
        attributes.keys
      else
        items = ['title', 'name', 'email', 'id', 'var']
        names = @record.class.attribute_names.select { |i| i.in? items }

        names.sort_by { |i| items.index i }.first(1)
      end
    end

    def attribute_labels
      attribute_names.map { |i| @model.human_attribute_name(i) }
    end

    def render_attribute(name, options={})
      @context.simple_attribute_for(@record, name, options.merge(namespace: 'Admin'))
    end

    def render_attributes(*args)
      options = args.extract_options!
      wrapper = args.first
      attribs = attribute_names.map do |a|
        @context.content_tag(wrapper, render_attribute(a), options)
      end

      attribs.join.html_safe
    end

    def render_attributes_labels(*args)
      options = args.extract_options!
      wrapper = args.first
      attribs = attribute_labels.map do |a|
        @context.content_tag(wrapper, a, options)
      end

      attribs.join.html_safe
    end

    def action_links(*args)
      options = args.extract_options!
      wrapper = args.first

      @context.content_tag wrapper, options do
        @context.admin_table_action_links(@record)
      end
    end

    def fields
      if self.record_fields.any?
        self.record_fields
      else
        Hash[@record.permitted_attributes.map { |e| [:"#{e}", {}] }]
      end
    end

    def render_field(form, field, options={})
      options     = Hash(options)
      association = options[:association]

      if association.present?
        form.association field, options.except(:association)
      else
        form.input field, options
      end
    end

    def render_fields(form)
      fields.map { |f, o| render_field(form, f, o) }.join.html_safe
    end

    def panels
      if self.record_panels.any?
        self.record_panels
      else
        { attributes: { title: 'Attributes', fields: fields.keys } }
      end
    end

    def render_panel(form, options={})
      template = "admin/panels/#{options.fetch :template, 'default'}"
      content  = Array(options[:fields]).map { |f| render_panel_field(form, f, options) }
      footer   = Array(Hash(options[:footer])[:fields]).map { |f| render_panel_field(form, f, options) }.join.html_safe
      footer   = nil if footer.blank?

      options = {
        layout:  false,
        content: content.join.html_safe,
        title:   options[:title],
        footer:  footer
      }

      @context.render template, options
    end

    def render_panel_field(form, field, options)
      opts = fields[field]

      opts[:label] = false if options[:labels] == false
      opts[:label] = true  if Array(options[:labels]).include?(field)

      render_field(form, field, opts)
    end

    def render_panels(options={})
      form    = options[:form]
      context = options[:context]

      panels_for_context(context).map { |_i, o| render_panel(form, o) }.join.html_safe
    end

    def sorted_panels
      items = [:high, :medium, :low]
      panels.sort_by { |_i, o| [items.index(o[:priority]).to_i, o[:order].to_i] }
    end

    def panels_for_context(context=nil)
      if context.blank?
        sorted_panels.select { |_i, o| o[:context].blank? }
      else
        sorted_panels.select { |_i, o| o[:context] == context }
      end
    end

    # def render_table(table)
    #   table = self.record_tables[table]
    # end

    def render_table_header(table)
      table = self.record_tables[table]
      cells = []

      table.header.each do |_k, v|
        cells << @context.content_tag(:th, v[:label], v[:html])
      end

      cells.join.html_safe
    end

    def render_table_columns(table)
      table = self.record_tables[table]
      cells = []

      table.columns.each do |k, v|
        options = v.fetch(:attribute, {})
        cells << @context.content_tag(:td, render_attribute(k, options), v[:html])
      end

      cells.join.html_safe
    end
  end
end
