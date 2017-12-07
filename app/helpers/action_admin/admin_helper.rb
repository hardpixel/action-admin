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
  end
end
