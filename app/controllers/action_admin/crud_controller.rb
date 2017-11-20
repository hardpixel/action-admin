module ActionAdmin
  class CrudController < BaseController
    def self.inherited(subclass)
      subclass.send(:include, ActionAdmin::Crudable)
    end
  end
end
