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
      title = Hash(actions[:"#{name}"])[:title] || default_title(context)
      evaluate_value(title, context)
    end

    def action_links(name, context)
      links = Hash(actions[:"#{name}"])[:links]

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
