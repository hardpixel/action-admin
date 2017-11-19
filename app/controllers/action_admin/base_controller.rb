module ActionAdmin
  class BaseController < ActionController::Base
    # Set layout
    layout 'admin'

    # Use forgery protection
    protect_from_forgery with: :exception

    # Render default view
    rescue_from ActionController::UnknownFormat, with: :render_default_view

    # Action callbacks
    before_action :set_meta

    private

      # Render default view template
      def render_default_view
        respond_to do |format|
          format.html { render 'admin/common/action' }
          format.json { render json: { message: 'No content' }, status: :unprocessable_entity }
        end
      end

      # Set meta tags
      def set_meta
        tags = {
          site:     'Bedrock',
          noindex:  true,
          nofollow: true,
          reverse:  true,
          title:    "#{controller_name.titleize} #{action_name.titleize}",
          charset:  'utf-8'
        }

        set_meta_tags tags
      end
  end
end
