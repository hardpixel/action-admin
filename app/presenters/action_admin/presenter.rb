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
        items = ['title', 'name', 'email', 'id']
        names = @record.class.attribute_names.select { |i| i.in? items }

        names.sort_by { |i| items.index i }.first(1)
      end
    end

    def attribute_labels
      attribute_names.map { |i| @model.human_attribute_name(i) }
    end

    def render_attribute(name)
      @context.simple_attribute_for(@record, name, Hash(attributes[name]))
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
      self.record_fields
    end

    def render_field(form, field, options={})
      form.input field, Hash(options)
    end

    def render_fields(form)
      fields.map { |f, o| render_field(form, f, 0) }.join.html_safe
    end

    def panels
      self.record_panels
    end

    def render_panel(form, options={})
      template = "admin/panels/#{options.fetch :template, 'default'}"
      content = Array(options[:fields]).map do |f|
        opts = fields[f]

        opts[:label] = false if options[:labels] == false
        opts[:label] = true  if Array(options[:labels]).include?(f)

        render_field(form, f, opts)
      end

      options = {
        layout:  false,
        content: content.join.html_safe,
        title:   options[:title],
        footer:  options[:footer]
      }

      @context.render template, options
    end

    def render_panels(form)
      panels.map { |i, o| render_panel(form, o) }.join.html_safe
    end
  end
end
