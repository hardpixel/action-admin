module ActionAdmin
  class Shortcode
    # Initializes the decorator
    def initialize(params, attribs={})
      attribs = Hash[attribs.map { |k, _v| [k, nil] }].symbolize_keys
      string  = URI.decode(params[:shortcode])

      @field  = params[:id]
      @object = parse_shortcode_attr(string, attribs)
    end

    # Sets the model name
    def model_name
      ActiveModel::Name.new(self.class, nil, @field)
    end

    # Delegates to the wrapped object
    def method_missing(method, *args, &block)
      if @object.key? method
        @object[method]
      elsif @object.respond_to? method
        @object.send(method, *args, &block)
      end
    end

    # Check if attribute exists
    def has_attribute?(attribute)
      @object.key? attribute
    end

    private

      # Checks if shortcode string is valid
      def valid_shortcode?(string)
        "#{string}".strip.match(/^\[(\w+) (.+?)\]$/).present? and
        parse_shortcode_field(string) == "#{@field}"
      end

      # Parses shortcode string and returns field name
      def parse_shortcode_field(string)
        "#{string}".match(/^\[(\w+) /).captures.first
      end

      # Parses shortcode string and returns attributes
      def parse_shortcode_attr(string, attribs)
        found = Hash["#{string}".scan(/(\w+)="([^"]+)"/)].symbolize_keys
        valid = found.select { |k, _v| k.in? attribs.keys }

        valid_shortcode?(string) ? attribs.merge(valid) : attribs
      end
  end
end
