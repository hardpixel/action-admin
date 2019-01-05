module ActionAdmin
  class MenuConfig < Hashie::Mash
    self.disable_warnings
  end

  class MenusConfig < Hashie::Mash
    self.disable_warnings
  end

  class ShortcodesConfig < Hashie::Mash
    self.disable_warnings
  end

  class Config < Hashie::Dash
    property :app_name,          default: 'Action Admin'
    property :app_urls,          default: :web_url
    property :admin_locale,      default: :en
    property :admin_index_scope, default: nil
    property :menus,             default: MenusConfig.new
    property :shortcodes,        default: ShortcodesConfig.new
    property :shortcode_helper,  default: :render_shortcode
    property :shortcode_layout,  default: 'shortcode'
    property :shortcode_assets,  default: ['application.css', 'application.js']
    property :shortcode_packs,   default: []
    property :google_maps_key,   default: nil

    def menu(name, &block)
      if self.menus.send(:"#{name}").nil?
        self.menus.send(:"#{name}=", MenuConfig.new)
      end

      yield self.menus.send(:"#{name}")
    end
  end
end
