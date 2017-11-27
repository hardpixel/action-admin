Rails.application.routes.draw do
  mount ActionAdmin::Engine, at: :admin, as: :admin
end
