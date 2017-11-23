module ActionAdmin
  class CrudController < ActionController::Base
    def self.inherited(subclass)
      subclass.send(:include, ActionAdmin::Crudable)
    end
  end
end
