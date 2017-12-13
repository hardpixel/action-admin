module ActionAdmin
  module Actionable
    extend ActiveSupport::Concern

    included do
      include Controller

      class_attribute :action_header
      class_attribute :_action_templates

      self.action_header     = Header.new
      self._action_templates = {}
    end

    class_methods do
      def action_title(action, title)
        self.action_header.action(action)
        self.action_header.title(title)
        self.action_header.action(nil)
      end

      def action_template(action, template, options={})
        self._action_templates = self._action_templates.merge(
          action => options.merge(partial: "admin/templates/#{template}")
        )
      end

      def header(action, &block)
        self.action_header.action(action)
        yield self.action_header
        self.action_header.action(nil)
      end
    end
  end
end
