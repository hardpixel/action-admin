module ActionAdmin
  module SimpleForm
    extend ActiveSupport::Autoload

    autoload :FormBuilder
    autoload :MinimalFormBuilder
    autoload :ErrorNotification
  end
end
