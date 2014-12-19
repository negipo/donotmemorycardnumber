class FriendsController < ApplicationController
  before_action :load_friends

  def index
    if params[:has_number]
      @friends = @friends.has_number
    end
  end

  def assign_numbers
    @friends.update_all(number: nil)
    @friends.sample(100).each_with_index do |friend, index|
      friend.update_attributes!(number: index)
    end
  end

  private

  def load_friends
    @friends = current_user.friends.name_kana_order
  end
end
