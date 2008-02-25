class UsersController < ApplicationController

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end
  def get_cert
    unless logged_in?
      redirect_back_or_default('/')
    else
      pkey = OpenSSL::PKey::RSA.new(File. read("cert/#{current_user.login}/#{current_user.login}_keypair.pem"))
      cert = OpenSSL::X509::Certificate.new(File.read("cert/#{current_user.login}/cert_#{current_user.login}.pem"))
      p12 = OpenSSL::PKCS12.create(nil, "#{current_user.login} cert", pkey, cert)
      send_data p12.to_der, :type => 'application/pkcs12', :filename => "#{current_user.login}.p12"
    end
  end
end
