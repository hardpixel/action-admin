module ActionAdmin
  class Devise::OmniauthCallbacksController < ::Devise::OmniauthCallbacksController
    include ActionAdmin::Actionable

    layout 'admin/devise'
  end
end
