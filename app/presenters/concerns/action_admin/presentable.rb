module ActionAdmin
  module Presentable
    extend ActiveSupport::Concern

    included do
      class_attribute :record_attributes
      class_attribute :record_fields
      class_attribute :record_panels
      class_attribute :record_tables

      self.record_attributes = {}
      self.record_fields     = {}
      self.record_panels     = {}
      self.record_tables     = {}
    end

    class_methods do
      def attribute(name, options = {})
        self.record_attributes = self.record_attributes.merge(name => options)
      end

      def field(name, options = {})
        self.record_fields = self.record_fields.merge(name => options)
      end

      def panel(name, options = {})
        self.record_panels = self.record_panels.merge(name => options)
      end

      def table(name, options = {}, &block)
        new_table = ActionAdmin::Table.new(name, options)
        new_table.merge(self.record_tables[name])

        yield new_table if block_given?

        self.record_tables = self.record_tables.merge(name => new_table)
      end
    end
  end
end
