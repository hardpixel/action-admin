module ActionAdmin
  module TagHelper
    # Google maps js API tag
    def google_maps_javascript_tag()
      api_key = ActionAdmin.config.google_maps_key
      api_url = 'https://maps.googleapis.com/maps/api/js?libraries=places'
      api_url = "#{api_url}&key=#{api_key}" if api_key.present?

      javascript_include_tag api_url
    end
  end
end
