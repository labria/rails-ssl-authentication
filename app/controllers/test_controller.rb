class TestController < ApplicationController
  def index
    if request.ssl?
      render :text => "ssl request"
    else
      render :text => "non-ssl request"
    end
  end
end
