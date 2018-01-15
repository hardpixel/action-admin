require 'hashie'
require 'simple_form'
require 'bedrock_sass'
require 'action_crud'
require 'smart_pagination'
require 'smart_navigation'
require 'simple_attribute'
require 'action_admin/routes'
require 'action_admin/engine'

module ActionAdmin
  extend ActiveSupport::Autoload

  # Autoload modules
  autoload :Config
  autoload :Form
  autoload :Header
  autoload :Table
  autoload :Shortcode

  # Set attr accessors
  mattr_accessor :config

  # Set config options
  @@config = Config.new

  # Setup module config
  def self.setup
    yield config
  end
end
