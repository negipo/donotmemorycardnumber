class HomeController < ApplicationController
  def index
    if current_user
      redirect_to friends_path
    end
  end
end
