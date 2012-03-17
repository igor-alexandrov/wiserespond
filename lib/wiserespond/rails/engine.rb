module Wiserespond
  module Rails
    class Engine < ::Rails::Engine      
      initializer "wiserespond.register" do |app|
        ::ActionController::Base.send :include, Wiserespond::ActionController
      end
    end
  end
end
