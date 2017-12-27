module ActionAdmin
  class Devise::RegistrationsController < ::Devise::RegistrationsController
    include ActionAdmin::Actionable

    action_title :new, 'Register'
    action_title :edit, 'Edit Profile'

    layout 'admin', only: :edit
    layout 'admin/devise', except: :edit
  end
end
