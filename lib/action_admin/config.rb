module ActionAdmin
  class Config < Hashie::Dash
    property :app_name,          default: 'Action Admin'
    property :app_urls,          default: :web_url
    property :admin_locale,      default: :en
    property :admin_index_scope, default: nil
    property :menus,             default: Hashie::Mash.new
    property :shortcodes,        default: Hashie::Mash.new
    property :shortcode_helper,  default: :render_shortcode
    property :shortcode_layout,  default: 'shortcode'
    property :shortcode_assets,  default: ['application.css', 'application.js']
    property :shortcode_packs,   default: []
    property :google_maps_key,   default: nil

    def menu(name, &block)
      if self.menus.send(:"#{name}").nil?
        self.menus.send(:"#{name}=", Hashie::Mash.new)
      end

      yield self.menus.send(:"#{name}")
    end
  end
end
