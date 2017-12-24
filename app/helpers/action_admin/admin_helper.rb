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

    def admin_render_template(fallback)
      template = Hash(controller._action_templates[:"#{action_name}"])
      partial  = template.fetch :partial, fallback
      options  = template.except(:partial)

      render partial, options
    end

    def admin_search?
      params[:search].present?
    end

    def merge_params(original, keys, candidates)
      original = Hash(original)
      selected = candidates.select { |k, _v| Array(keys).include? :"#{k}" }

      original.merge(selected)
    end

    def admin_search_url
      url_for merge_params({}, [:per_page, :filter, :sort], params.permit(:per_page, filter: {}, sort: {}).to_h)
    end

    def admin_shortcode_present(shortcode, presenter=nil)
      class_name = shortcode.classify
      presenter  = presenter || "Admin::Shortcode::#{class_name}Presenter"
      presenter  = "#{presenter}".safe_constantize || 'ActionAdmin::ShortcodePresenter'.constantize

      presenter.new(shortcode, self)
    end

    def admin_render_shortcode(string)
      method(ActionAdmin.config.shortcode_helper).call(string)
    end

    def admin_shortcode_assets
      assets = ActionAdmin.config.shortcode_assets.map do |asset|
        name, type = asset.split('.')
        type == 'css' ? stylesheet_link_tag(name) : javascript_include_tag(name)
      end

      packs = ActionAdmin.config.shortcode_packs.map do |asset|
        name, type = asset.split('.')
        type == 'css' ? stylesheet_pack_tag(name) : javascript_pack_tag(name)
      end

      assets.join.html_safe + packs.join.html_safe
    end
  end
end
