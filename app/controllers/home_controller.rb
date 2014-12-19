class HomeController < ApplicationController
  def index
    if current_user
      rediret_to friends_path
    end
  end
end
