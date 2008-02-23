class TestController < ApplicationController
  def index
    if request.env["HTTP_X_SSL_CLIENT_S_DN"]
      pairs = request.env["HTTP_X_SSL_CLIENT_S_DN"].split("/").
        delete_if{ |x| x == ""}.
        map{|p| p.split("=")}.flatten
      @info = Hash.[](*pairs)
    else
      render :text => "No header found!"
    end
  end
end
