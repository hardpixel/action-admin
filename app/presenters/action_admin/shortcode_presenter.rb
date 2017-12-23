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
      association = options[:association]

      if association.present?
        form.association field, Hash(options).except(:association)
      else
        form.input field, Hash(options)
      end
    end

    def render_fields(form)
      fields.map { |f, o| render_field(form, f, 0) }.join.html_safe
    end
  end
end
