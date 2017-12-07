module ActionAdmin
  class Devise::UnlocksController < ::Devise::UnlocksController
    include ActionAdmin::Actionable

    action_title :new, 'Unlock Instructions'
    action_title :show, 'Unlock Account'

    layout 'admin/devise'
  end
end
