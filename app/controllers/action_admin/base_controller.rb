module ActionAdmin
  class BaseController < ActionController::Base
    def self.inherited(subclass)
      subclass.send(:include, ActionAdmin::Actionable)
    end
  end
end
