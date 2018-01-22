class ActionAdmin::Devise::OmniauthCallbacksController < ::Devise::OmniauthCallbacksController
  include ActionAdmin::Actionable

  layout 'admin/devise'
end
