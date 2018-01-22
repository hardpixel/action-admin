class ActionAdmin::Devise::ConfirmationsController < ::Devise::ConfirmationsController
    include ActionAdmin::Actionable

    action_title :new, 'Confirm Account'
    action_title :show, 'Confirmed Account'

    layout 'admin/devise'
end
