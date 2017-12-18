module ActionAdmin
  module MarkupHelper
    def admin_icon(name, options={})
      opts = options.except(:text, :revert).merge(class: "mdi mdi-#{name}")
      icon = content_tag :i, nil, opts if name.present?
      text = options[:text]
      data = options[:revert].present? ? [text, icon] : [icon, text]

      data.join(' ').html_safe
    end

    def admin_pagination(records, options={})
      options = options.merge({
        previous_class: 'pagination-previous',
        next_class:     'pagination-next',
        active_class:   'current'
      })

      smart_pagination_for(records, options)
    end

    def admin_table_pagination(records)
      info  = content_tag :div, smart_pagination_info_for(records), class: 'shrink cell'
      links = admin_pagination(records, wrapper_class: 'pagination margin-0')
      links = content_tag :div, links, class: 'auto cell text-right'

      content_tag :div, info + links, class: 'grid-x'
    end

    def admin_settings_menu(records, label_method=:id)
      options = {
        menu_class:           'tabs menu margin-bottom-2',
        item_class:           'tabs-title',
        separator_class:      'is-separator',
        submenu_parent_class: 'has-children',
        submenu_class:        'vertical menu nested',
        active_class:         'active',
        active_submenu_class: 'active',
        icon_prefix:          'mdi mdi-',
        icon_position:        'left'
      }

      items = records.map do |record|
        label = record.send(label_method)
        url   = edit_record_url(record)

        [:"#{label.downcase.underscore}", { label: label, url: url }]
      end

      smart_navigation_for Hash[items], options
    end

    def admin_primary_menu
      options = {
        menu_class:           'vertical menu icons icon-left accordion-menu',
        menu_html:            { 'data-accordion-menu': '', 'data-submenu-toggle': true },
        separator_class:      'is-separator',
        submenu_parent_class: 'has-children',
        submenu_class:        'vertical menu nested',
        active_class:         'is-current',
        active_submenu_class: 'is-current',
        icon_prefix:          'mdi mdi-'
      }

      smart_navigation_for ActionAdmin.config.menus.primary, options
    end

    def admin_secondary_menu
      options = {
        menu_class:           'vertical menu secondary icons icon-right',
        separator_class:      'is-separator',
        submenu_parent_class: 'has-children',
        submenu_class:        'vertical menu nested',
        active_class:         'is-current',
        active_submenu_class: 'is-current',
        icon_prefix:          'mdi mdi-',
        icon_position:        'right'
      }

      smart_navigation_for ActionAdmin.config.menus.secondary, options
    end

    def admin_topbar_menu(position)
      items = {
        left: {
          toggle: { icon: 'menu', html: { 'data-toggle': 'sidebar' } }
        },
        right: {
          website: { url: :root_url, icon: 'web', html: { target: :_blank } }
        }
      }

      options = {
        menu_class:           'menu icons icon-left',
        separator_class:      'is-separator',
        submenu_parent_class: 'has-children',
        submenu_class:        'vertical menu nested',
        active_class:         'is-current',
        active_submenu_class: 'is-current',
        icon_prefix:          'mdi mdi-',
        icon_position:        'left'
      }

      custom = ActionAdmin.config.menus.send(:"topbar_#{position}")
      items  = items[position].merge(Hash(custom).symbolize_keys)

      smart_navigation_for items, options
    end

    def admin_action_links(action=nil)
      name  = action || action_name
      links = controller.action_header.action_links(name, self).map do |link|
        opts    = Hash(link[:html]).merge(method: link[:method])
        classes = "button small hollow #{opts[:class]}".strip
        label   = admin_icon(link[:icon], text: link[:label])

        link_to label, link[:url], opts.merge(class: classes)
      end

      links.join(' ').html_safe
    end

    def admin_table_action_links(record, actions=nil)
      options = {
        show:    { label: admin_icon('eye'), title: 'View', class: 'success' },
        edit:    { label: admin_icon('pencil'), title: 'Edit' },
        destroy: { label: admin_icon('delete'), title: 'Delete', class: 'alert' }
      }

      options = options.select { |k, _v| k.in? actions } if actions.present?
      options = options.merge(html: { class: 'button hollow' })

      record_links_to record, options
    end
  end
end
