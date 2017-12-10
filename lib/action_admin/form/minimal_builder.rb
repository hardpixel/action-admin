module ActionAdmin
  module Form
    class MinimalBuilder < Builder
      # Form builder input
      def input(attribute_name, options = {}, &block)
        options  = @defaults.deep_dup.deep_merge(options) if @defaults
        input    = find_input(attribute_name, options, &block)
        excluded = [:radio, :checkbox, :boolean, :check_boxes, :radio_buttons]

        if !input.input_type.in?(excluded) and options[:placeholder].nil?
          options[:placeholder] ||= input.send(:raw_label_text)
          options[:label]       ||= false
        end

        super
      end
    end
  end
end
