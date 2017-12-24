module ActionAdmin
  class ShortcodesController < ActionController::Base
    layout nil, except: :preview
    layout ActionAdmin.config.shortcode_layout, only: :preview

    def list
      shortcodes = ActionAdmin.config.shortcodes
      shortcodes.each do |key, value|
        shortcodes[key][:icon] = "mdi mdi-#{value[:icon]}" if value[:icon].present?
      end

      render json: shortcodes
    end

    def form
      @shortcode = params[:id]
    end

    def preview
      @shortcode = params[:shortcode]
    end
  end
end
