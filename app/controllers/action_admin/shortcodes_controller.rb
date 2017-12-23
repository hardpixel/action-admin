module ActionAdmin
  class ShortcodesController < ActionController::Base
    layout nil

    def list
      shortcodes = ActionAdmin.config.shortcodes
      shortcodes.each do |key, value|
        shortcodes[key][:icon] = "mdi mdi-#{value[:icon]}" if value[:icon].present?
      end

      render json: shortcodes.to_json
    end

    def form
    end

    def preview
    end
  end
end
