module ActionAdmin
  class Devise::PasswordsController < ::Devise::PasswordsController
    include ActionAdmin::Actionable

    action_title :new,  'Forgot Password'
    action_title :edit, 'Reset Password'

    layout 'admin/devise'
  end
end
