module ActionAdmin
  module AdminHelper
    def admin_pagination(records)
      options = {
        previous_class: 'pagination-previous',
        next_class:     'pagination-next',
        active_class:   'current'
      }

      smart_pagination_for(records, options)
    end
  end
end
