require 'wiserespond/rails' if defined?(Rails)

module Wiserespond
  module ActionController
    def respond_with_redirect(options={})
      options.reverse_merge!(
        :flash => nil,
        :status => :success
      )
      
      self.setup_flash_for_redirect(options)
      
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
      
      self.setup_flash_for_content(options)
      
      respond_to do |format|
        format.html { render options[:action] }
        format.js { render :template => 'wiserespond/content', :locals => options }
      end
    end
    
    def setup_flash_for_redirect(options)
      message = options.delete(:flash)
      flash[options[:status]] = message if message.present?
    end
    protected :setup_flash_for_redirect   
    
    def setup_flash_for_content(options) 
      message = options.delete(:flash)
      options[:flash] = { options[:status] => message } if message.present?
    end
    protected :setup_flash_for_content   
  end
end
