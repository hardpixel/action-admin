module ActionAdmin
  module Actionable
    extend ActiveSupport::Concern

    included do
      include Base

      class_attribute :action_header
      self.action_header = Header.new
    end

    class_methods do
      def header(action, &block)
        self.action_header.action(action)
        yield self.action_header
        self.action_header.action(nil)
      end
    end
  end
end