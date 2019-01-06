module ActionAdmin
  class Table
    class_attribute :name
    class_attribute :options
    class_attribute :columns
    class_attribute :header

    def initialize(name, options)
      self.name    = name
      self.options = options
      self.columns = {}
      self.header  = {}
    end

    def column(name, options={})
      self.columns = self.columns.merge(name => options)
      self.header  = self.header.merge(name => set_column_header(name, options))
    end

    def merge(table)
      if table.is_a? ActionAdmin::Table
        self.options = table.options.deep_merge(self.options)
        self.columns = table.columns.merge(self.columns)
        self.header  = table.header.merge(self.header)
      end
    end

    private

    def set_column_header(name, options = {})
      label = options.fetch(:label, name.to_s.titleize)
      html  = options.fetch(:html, {})

      { label: label, html: html }
    end
  end
end
