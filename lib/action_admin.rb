require 'action_crud'
require 'hashie'
require 'action_admin/engine'

module ActionAdmin
  extend ActiveSupport::Autoload

  # Autoload modules
  autoload :Config
  autoload :SimpleForm
  autoload :Controller
  autoload :Actionable
  autoload :Crudable
  autoload :Header

  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = Config.new

  # Setup module config
  def self.setup
    yield config
  end
end
