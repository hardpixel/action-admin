module ActionDispatch::Routing
  class Mapper
    def authenticate_admin(resource, options = {})
      space   = options.fetch :namespace, :admin
      path    = options.fetch :path, "#{space}/#{resource}"
      model   = "#{resource}".pluralize
      names   = { sign_in: 'login', sign_out: 'logout', sign_up: 'signup', edit: 'profile' }
      options = { path: path, path_names: names, module: 'action_admin/devise' }.merge(options)

      devise_for :"#{model}", options

      authenticate resource do
        namespace space do
          yield
        end
      end
    end
  end
end
