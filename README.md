[![Build Status](https://secure.travis-ci.org/igor-alexandrov/wiserespond.png)](http://travis-ci.org/igor-alexandrov/wiserespond)

# wiserespond

Rails 3 responders to make you controllers DRY.

## Installation

Add this to your Gemfile:

    gem 'wiserespond'

then do:
    
    bundle
  

## How does it work?

### Without `wiserespond`

I a lot of Rails projects I see code like:
  
    class BrandsController < ApplicationController
      before_filter :fetch_brand

      def edit
        # Here is some code 
      end

      def update
        authorize! :update, @brand
        if @brand.update_attributes(params[:brand])  
          respond_to do |format|
            format.html{ redirect_to brand_url(@brand) }
            format.js # Here will be rendered something like 'brands/update.js.erb'
          end
        else
          respond_to do |format|
            format.html{ render :action => :edit }
            format.js # Here again be rendered 'brands/update.js.erb'
          end                  
        end
      end
    end

Then your `brands/update.js.erb` can look like this:
  
    <% if @brand.errors.any? %>
      $('#brand').replaceWith('<%= escape_javascript(render :partial => "brands/form", :locals => { :brand => @brand }) %>')
    <% else %>
      window.location.href="<%= brand_url(@brand).html_safe %>";
    <% end %>
    
Or, if you use History API, or maybe Fancybox and you have to setup some features in you form and show flash message, it will be a bit more complex:
    
    <% if @brand.errors.any? %>
      $('#brand').replaceWith('<%= escape_javascript(render :partial => "brands/form", :locals => { :brand => @brand }) %>')
      appSetupAllFeatures(#brand);      
      Flash.notification('An error occured while saving your brand');
    <% else %>
      $.fancybox.close();
      History.replaceState({timestamp: (new Date().getTime()), slide: true}, document.title, "<%= brand_url(@brand).html_safe %>");            
    <% end %>

If you have to do this only once – this is OK. But what if out app consists of more then one controller and every controller has more then two actions?

Of course we can create

* `brands/update.js.erb`
* `brands/create.js.erb`
* `brands/some_other_action.js.erb`
* `other_model/some_other_action.js.erb`

and so on… This list can be rather long. Not a Rails-way at all.

### With `wiserespond`

Wiserespond does not try to invent some new way of writing controllers, it also does not have any magic. All is clear and easy to understand. Lets start with refactored example of out controller:
 
    class BrandsController < ApplicationController
      before_filter :fetch_brand

      def edit
        # Here is some code 
      end

      def update
        authorize! :update, @brand
        if @brand.update_attributes(params[:brand])  
          respond_with_redirect :url => brand_url(@brand)
        else
          respond_with_content :action => :edit, :id => '#brand', :partial => 'brands/form'
        end
      end
    end

Looks great? For me – yes! And works great too.

Wiserespond aggregates `html` and `js` content types responds, make redirection or action rendering on `html` content type and adds default templates to `js` content type. Here is `wiserespond/content.js.erb`:

    <% if local_assigns[:id].present? && local_assigns[:partial].present? %>
      $('#<%= id %>').replaceWith('<%= escape_javascript(render :partial => "#{partial}", :locals => locals) %>')
    <% end %>
    
and here  `wiserespond/redirect.js.erb`:

    <% if local_assigns[:url].present? %>
      window.location.href="<%= url.html_safe %>";
    <% end %>
    
Of course you can redefine this templates in your application. Just create then in `app/views/wiserespond` directory.

For example, I use History API and want to pass some additional information to my JS code, here is what I have in `app/views/wiserespond/redirect.js.erb`:
    
    History.replaceState({timestamp: (new Date().getTime()), slide: true}, document.title, "<%= url.html_safe %>");

    $.fancybox.close();

    <% if local_assigns[:ids].present? %>
      $('.sidebar').trigger('update.cells_liens_tree', {ids: <%= ids %>});
      $('.sidebar').trigger('update.cells_auctions_tree', {ids: <%= ids %>});
      $('.sidebar').trigger('update.cells_liens_shared', {ids: <%= ids %>});
    <% end %>

And here is how I call in controller:
    
    if @portfolio.update_attributes(params[:portfolio])
      respond_with_redirect :url => portfolio_url(@portfolio), :ids => @portfolio.affected_widget_ids, :flash => 'Portfolio was successfully updated.'
    else

Make your controllers as DRY as you can!

## Production?  

**wiserespond** is used at:

* [www.sdelki.ru](http://www.sdelki.ru)
* [www.lienlog.com](http://www.lienlog.com)

Know other projects? Then contact me and I will add them to the list.

## Contributing to wiserespond
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Igor Alexandrov. See LICENSE.txt for
further details.