module ActionAdmin
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.template_engine :slim
    end

    initializer 'action_admin.assets.precompile' do |app|
      %w(action_admin admin).each do |sf|
        app.config.assets.paths << root.join('app', 'assets', 'javascripts', sf).to_s
        app.config.assets.paths << root.join('app', 'assets', 'stylesheets', sf).to_s
        app.config.assets.paths << root.join('app', 'assets', 'images', sf).to_s
      end

      app.config.assets.precompile += %w(admin/application.js admin/application.css admin/tinymce-editor.css images/admin/*.*)
    end

    initializer 'action_admin', before: :load_config_initializers do
      Rails.application.routes.append do
        mount ActionAdmin::Engine, at: 'admin'
      end
    end
  end
end
