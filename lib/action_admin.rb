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

  autoload :Config
  autoload :Form
  autoload :Header
  autoload :Table
  autoload :Shortcode

  mattr_accessor :config

  @@config = Config.new

  def self.setup
    yield config
  end
end

ActiveSupport.on_load(:active_record) do
  include ActionAdmin::Form::Uploadable
end
