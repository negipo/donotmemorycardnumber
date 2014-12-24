class MemoriesController < ApplicationController
  def index
    @friends = current_user.friends.has_number
  end
end
