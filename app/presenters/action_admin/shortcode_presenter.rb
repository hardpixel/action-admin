module ActionAdmin
  class ShortcodePresenter
    include ActionAdmin::Presentable

    def initialize(shortcode, context)
      @shortcode = shortcode
      @context   = context
    end

    def fields
      self.record_fields
    end

    def render_field(form, field, options={})
      options = Hash(options)

      options[:input_html]        ||= {}
      options[:input_html][:data] ||= {}

      options[:input_html][:data][:attribute] = field
      options[:input_html][:include_hidden]   = false

      form.input field, options
    end

    def render_fields(form)
      fields.map { |f, o| render_field(form, f, o) }.join.html_safe
    end
  end
end
