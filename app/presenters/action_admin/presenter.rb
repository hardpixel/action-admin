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
  end
end
