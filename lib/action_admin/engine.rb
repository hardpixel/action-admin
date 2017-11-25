module ActionAdmin
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.template_engine :slim
    end

    initializer 'action_admin.assets.precompile' do |app|
      app.config.assets.precompile += %w(admin/*)
    end

    initializer 'action_admin', before: :load_config_initializers do
      Rails.application.routes.append do
        mount ActionAdmin::Engine, at: 'admin'
      end
    end
  end
end
