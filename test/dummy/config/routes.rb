Rails.application.routes.draw do
  mount ActionAdmin::Engine, at: :admin, as: :admin_test
end
