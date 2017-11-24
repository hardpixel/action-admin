require 'action_crud'
require 'action_admin/engine'

module ActionAdmin
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Actionable
  autoload :Crudable
  autoload :Header
end
