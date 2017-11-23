module ActionAdmin
  class Header
    class_attribute :actions
    class_attribute :current_actions

    def initialize
      self.actions = {}
    end

    def action(names)
      self.current_actions = Array(names)
    end

    def title(value)
      current_actions.each { |a| add_action_key(a, :title, value) }
    end

    def link(options)
      current_actions.each { |a| add_action_key(a, :links, options, true) }
    end

    def action_title(name, context)
      title = Hash(actions[:"#{name}"]).fetch :title, default_title(context)
      evaluate_value(title, context)
    end

    def action_links(name, context)
      links = Hash(actions[:"#{name}"]).fetch :links, default_action_links(name, context)

      Array(links).map do |link|
        Hash[link.map { |k, v| [k, evaluate_value(v, context)] }]
      end
    end

    def default_title(context)
      if context.action_name == 'index'
        context.controller_name.titleize
      else
        context.action_name.titleize
      end
    end

    def default_action_links(name, context)
      setup = { index: :new, new: :index, show: [:index, :edit, :destroy], edit: [:index, :show, :destroy] }
      links = default_links(context)

      Array(setup[:"#{name}"]).map { |l| links[l] }.reject(&:nil?)
    end

    def default_links(context)
      return {} unless context.controller.respond_to? :permitted_params

      {
        show:    { label: 'View',   icon: 'eye',        url: :record_path },
        index:   { label: 'Back',   icon: 'arrow-left', url: :records_path,     html: { class: 'inactive' } },
        new:     { label: 'New',    icon: 'plus',       url: :new_record_path,  html: { class: 'success' } },
        edit:    { label: 'Edit',   icon: 'pencil',     url: :edit_record_path, html: { class: 'warning' } },
        destroy: { label: 'Delete', icon: 'delete',     url: :record_path,      html: { class: 'alert' }, method: 'delete' }
      }
    end

    private

      def add_action_key(action, key, value, append=false)
        self.actions[action] = {} unless self.actions.key?(action)

        if append.present?
          self.actions[action][key]  = Array(self.actions[action][key])
          self.actions[action][key] += [value]
        else
          self.actions[action][key] = value
        end
      end

      def evaluate_value(value, context)
        if value.is_a?(Proc)
          context.instance_exec(&value)
        elsif value.is_a?(Symbol)
          context.try(value) || value
        else
          value
        end
      end
  end
end
