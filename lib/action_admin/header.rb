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
  end
end
