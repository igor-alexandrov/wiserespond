module Wiserespond
  module Rails
    class Engine < ::Rails::Engine
      initializer "wiserespond.register" do
        ::ActionController::Base.send :include, Wiserespond::ActionController
      end
    end
  end
end
