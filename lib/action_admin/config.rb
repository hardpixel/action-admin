module ActionAdmin
  class Config < Hashie::Dash
    property :app_name, default: 'Action Admin'
    property :menus, default: Hashie::Mash.new

    def menu(name, &block)
      if self.menus.send(:"#{name}").nil?
        self.menus.send(:"#{name}=", Hashie::Mash.new)
      end

      yield self.menus.send(:"#{name}")
    end
  end
end
