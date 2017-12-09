module ActionAdmin
  module Presentable
    extend ActiveSupport::Concern

    included do
      class_attribute :record_attributes
      class_attribute :record_fields

      self.record_attributes = {}
      self.record_fields     = {}
    end

    class_methods do
      def attribute(name, options={})
        self.record_attributes = self.record_attributes.merge(name => options)
      end

      def field(name, options={})
        self.record_fields = self.record_fields.merge(name => options)
      end
    end
  end
end
