module ActionAdmin
  module AdminHelper
    def admin_icon(name, options={})
      opts = options.except(:text, :revert).merge(class: "mdi mdi-#{name}")
      icon = content_tag :i, nil, opts if name.present?
      text = options[:text]
      data = options[:revert].present? ? [text, icon] : [icon, text]

      data.join(' ').html_safe
    end

    def admin_pagination(records)
      options = {
        previous_class: 'pagination-previous',
        next_class:     'pagination-next',
        active_class:   'current'
      }

      smart_pagination_for(records, options)
    end

    def admin_action_title(action=nil)
      name  = action || action_name
      title = controller.action_header.actions[:"#{name}"][:title]

      if title.is_a?(Proc)
        instance_exec(&title)
      elsif title.is_a?(Symbol)
        send(title)
      else
        title
      end
    end

    def admin_action_links(action=nil)
      name  = action || action_name
      links = controller.action_header.actions[:"#{name}"][:links].map do |link|
        url = link[:url]
        url = begin
          if url.is_a?(Proc)
            instance_exec(&url)
          elsif url.is_a?(Symbol)
            send(url)
          else
            url
          end
        end

        opts    = Hash(link[:html]).merge(method: link[:method])
        classes = "button small hollow #{opts[:class]}".strip
        label   = admin_icon(link[:icon], text: link[:label])

        link_to label, url, opts.merge(class: classes)
      end

      links.join(' ').html_safe
    end
  end
end
