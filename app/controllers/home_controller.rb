class HomeController < ApplicationController
  def index
    binding.pry if current_user
  end
end
