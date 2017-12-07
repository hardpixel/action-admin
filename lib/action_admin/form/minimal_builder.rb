module ActionAdmin
  module Form
    class MinimalBuilder < Builder
      # Form builder input
      def input(attribute_name, options = {}, &block)
        if options[:placeholder].nil?
          options[:placeholder] ||= if object.class.respond_to?(:human_attribute_name)
            object.class.human_attribute_name(attribute_name.to_s)
          else
            attribute_name.to_s.humanize
          end

          options[:label] = false if options[:label].nil?
        end

        super
      end
    end
  end
end
