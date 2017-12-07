module ActionAdmin
  module Controller
    extend ActiveSupport::Concern

    included do
      # Set layout
      layout 'admin'

      # Use forgery protection
      protect_from_forgery with: :exception

      # Render default view
      rescue_from ActionController::UnknownFormat, with: :render_default_view
    end

    private

      # Render default view template
      def render_default_view
        respond_to do |format|
          format.html { render 'admin/common/action' }
          format.json { render json: { message: 'No content' }, status: :unprocessable_entity }
        end
      end
  end
end
