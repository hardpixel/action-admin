module ActionAdmin
  class Devise::RegistrationsController < ::Devise::RegistrationsController
    include ActionAdmin::Actionable

    action_title :new, 'Register'
    action_title :edit, 'Edit Profile'

    layout -> { action_name == 'edit' ? 'admin' : 'admin/devise' }
  end
end
