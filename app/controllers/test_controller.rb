class TestController < ApplicationController
  def index
  end
  
  def cert_login
    render :text => "Yeah! It worked. You just logged in with your certificate!"
  end
end
