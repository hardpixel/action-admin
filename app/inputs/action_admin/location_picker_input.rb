module ActionAdmin
  class LocationPickerInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options)
      input_html_options[:name]          = nil
      input_html_options[:value]         = nil
      input_html_options[:placeholder] ||= raw_label_text
      input_html_options[:type]        ||= 'text'
      input_html_options[:data]        ||= {}
      input_html_options[:class]       ||= []
      input_html_options[:class]        += ['margin-bottom-1']

      input_html_options[:data].merge!({ place_autocomplete: '' })
      picker_data_options = { location_picker: '' }

      template.content_tag :div, class: 'location-picker', data: picker_data_options  do
        template.concat lat_hidden_field
        template.concat lng_hidden_field
        template.concat super
        template.concat location_map
      end
    end

    def lat_hidden_field
      attrib = options.fetch :lat, :longitude
      @builder.hidden_field(attrib, data: { location_lat: '' })
    end

    def lng_hidden_field
      attrib = options.fetch :lng, :longitude
      @builder.hidden_field(attrib, data: { location_lng: '' })
    end

    def location_map
      content_tag :div, nil, class: 'place-map', data: { place_map: '' }
    end

    def label(wrapper_options)
      ''
    end
  end
end
