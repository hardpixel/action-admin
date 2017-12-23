ActionAdmin::Engine.routes.draw do
  root 'action_admin/welcome#index'

  scope :shortcodes do
    get 'list',        to: 'action_admin/shortcodes#list',    as: :shortcode_list
    get 'form/:id',    to: 'action_admin/shortcodes#form',    as: :shortcode_form
    get 'preview/:id', to: 'action_admin/shortcodes#preview', as: :shortcode_preview
  end
end
