module ActionAdmin
  module Crudable
    extend ActiveSupport::Concern

    included do
      include Actionable
      include ActionCrud

      set_index_scope ActionAdmin.config.admin_index_scope
      set_namespace :admin
      permit_params except: [:created_at, :updated_at, :type, :ancestry]
    end

    class_methods do
      def controller_path
        'admin/records'
      end
    end
  end
end
