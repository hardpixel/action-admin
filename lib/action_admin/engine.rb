module ActionAdmin
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.template_engine :slim
    end

    initializer "action_admin.assets.precompile" do |app|
      app.config.assets.precompile += %w(admin/*)
    end
  end
end
