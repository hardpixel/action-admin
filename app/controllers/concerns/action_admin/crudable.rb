module ActionAdmin
  module Crudable
    extend ActiveSupport::Concern

    included do
      include ActionCrud
    end

    class_methods do
      def controller_path
        'admin/records'
      end
    end
  end
end
