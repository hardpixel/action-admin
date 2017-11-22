module ActionAdmin
  module Actionable
    extend ActiveSupport::Concern

    included do
      class_attribute :action_header

      before_action do
        self.class.header :new do |h|
          h.title 'Test PAGE'
        end
      end
    end

    class_methods do
      def header(action, &block)
        self.action_header = ActionAdmin::Header.new unless action_header?
        self.action_header.action(action)

        yield self.action_header
        self.action_header.action(nil)
      end
    end
  end
end
