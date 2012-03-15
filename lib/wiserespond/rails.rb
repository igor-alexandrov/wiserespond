module Pdf
  module Rails
    if ::Rails::VERSION::MAJOR > 2
      if ::Rails::VERSION::MINOR < 1
        require 'wiserespond/rails/railtie'
      else
        require 'wiserespond/rails/engine'
      end  
    end    
  end
end
