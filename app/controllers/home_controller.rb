class HomeController < ApplicationController
  def index
  end

  private

  def facebook_token
    request.env['omniauth.auth']["credentials"]["token"]
  end
end
