module ActionAdmin
  module Form
    extend ActiveSupport::Autoload

    autoload :Builder
    autoload :MinimalBuilder
    autoload :ErrorNotification
    autoload :Uploadable
  end
end
