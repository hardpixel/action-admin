module ActionAdmin
  class ShortcodesController < ActionController::Base
    layout nil, except: :preview
    layout ActionAdmin.config.shortcode_layout, only: :preview

    def list
      shortcodes = ActionAdmin.config.shortcodes
      shortcodes.each do |key, value|
        shortcodes[key][:icon] = "mdi mdi-#{value[:icon]}" if value[:icon].present?
      end

      render json: shortcodes.to_json
    end

    def form
      @shortcode = params[:id]
    end

    def preview
      # @shortcode = params[:shortcode]
      name  = params[:id]
      attrs = params[name]
      attrs = attrs.permit!.to_h.reject { |_k, v| v.blank? }.map { |k, v| "#{k}=\"#{Array(v).join(',')}\"" } if attrs.present?

      @shortcode = "[#{name} #{Array(attrs).join(' ')}]" if attrs.present?
    end
  end
end
