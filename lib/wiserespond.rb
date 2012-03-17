require 'wiserespond/rails' if defined?(Rails)

module Wiserespond
  module ActionController
    def respond_with_redirect(options={})
      options.reverse_merge!(
        :flash => nil,
        :status => :success
      )
      
      self.wiserespond_setup_flash(options)
      
      respond_to do |format|
        format.html { redirect_to options[:url] }
        format.js { render :template => 'wiserespond/redirect', :locals => options }        
      end
    end

    def respond_with_content(options={})
      options.reverse_merge!(
        :flash => nil,
        :status => :success,
        :locals => nil
      )
      
      self.wiserespond_setup_flash(options)
      
      respond_to do |format|
        format.html { render options[:action] }
        format.js { render :template => 'wiserespond/content', :locals => options }
      end
    end
    
    def wiserespond_setup_flash(options)
      if options[:flash].present?
        case options[:status]
        when :success
          flash[:notice] = options[:flash] 
        else  
          flash[:warning] = options[:flash] 
        end
      end      
    end
    protected :wiserespond_setup_flash    
  end
end
