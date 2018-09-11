module ActionAdmin
  module Form
    module Uploadable
      extend ActiveSupport::Concern

      class_methods do
        def multiupload_field(name)
          attr_name = :"#{name}"
          attr_curr = :"current_#{name}"
          attr_prev = :"previous_#{name}"

          [attr_curr, attr_prev].each do |attr_method|
            define_method attr_method do
              instance_variable_get("@#{attr_method}") || []
            end

            define_method :"#{attr_method}=" do |new_value|
              instance_variable_set("@#{attr_method}", new_value || [])
            end
          end

          after_initialize do |record|
            current = record.send(attr_name)
            record.send :"#{attr_prev}=", current

            if current
              current = current.map { |i| i.file.file }
              record.send :"#{attr_curr}=", current.uniq
            end
          end

          before_validation do |record|
            curr_files = Array(record.send(attr_curr)).reject(&:blank?)
            keep_files = Array(record.send(attr_prev)).select { |i| i.file.file.in? curr_files }
            drop_files = Array(record.send(attr_name)).any? { |i| !i.file.file.in? curr_files }

            if send(:"#{attr_name}_cache").present?
              new_files = record.send(attr_name)
              all_files = keep_files + new_files

              record.send :"#{attr_name}=", all_files.uniq { |i| i.file.file }
            elsif drop_files.present?
              record.send :"#{attr_name}=", keep_files.uniq { |i| i.file.file }
            end
          end
        end
      end
    end
  end
end
