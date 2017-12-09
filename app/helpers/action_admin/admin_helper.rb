module ActionAdmin
  module AdminHelper
    def admin_app_name
      ActionAdmin.config.app_name
    end

    def admin_action_title(action=nil)
      if controller.respond_to? :action_header
        name = action || action_name
        controller.action_header.action_title(name, self)
      end
    end

    def admin_meta_tags
      tags = {
        site:     admin_app_name,
        noindex:  true,
        nofollow: true,
        reverse:  true,
        title:    admin_action_title || "#{action_name}".titleize,
        charset:  'utf-8',
        viewport: 'width=device-width, initial-scale=1.0'
      }

      set_meta_tags tags
      display_meta_tags
    end

    def admin_present(record, presenter=nil)
      record     = record.new if record.respond_to? :new
      class_name = record.class.name
      presenter  = presenter || "Admin::#{class_name}Presenter"
      presenter  = "#{presenter}".safe_constantize || 'ActionAdmin::Presenter'.constantize

      presenter.new(record, self)
    end

    def admin_present_many(records, presenter=nil)
      records.to_a.map { |r| admin_present(r, presenter) }
    end
  end
end
