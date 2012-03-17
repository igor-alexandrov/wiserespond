module Wiserespond
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "wiserespond.register" do        
        ::ActionController::Base.send :include, Wiserespond::ActionController
      end            
    end
  end
end