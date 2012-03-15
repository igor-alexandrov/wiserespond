require 'helper'
 
class ApplicationControllerTest < ActionController::TestCase
  tests ApplicationController
 
  context "The controller" do
    should "respond to #respond_with_content" do
      assert_respond_to @controller, :respond_with_content
    end
    
    should "respond to #respond_with_redirect" do
      assert_respond_to @controller, :respond_with_redirect
    end
    
  end
end