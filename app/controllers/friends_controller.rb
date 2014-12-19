class FriendsController < ApplicationController
  SINGLE_ENTRY_ACTIONS = %i(show update)
  before_action :load_friends, except: SINGLE_ENTRY_ACTIONS
  before_action :load_friend, only: SINGLE_ENTRY_ACTIONS

  def index
    if params[:has_number]
      @friends = @friends.has_number
    end
  end

  def show
  end

  def update
    args = params[:friend]
    @friend.update_attributes!(name: args[:name], number: args[:number].presence)
    redirect_to friends_path(anchor: "friend_#{@friend.id}")
  end

  def assign_numbers
    raise
    @friends.update_all(number: nil)
    @friends.sample(100).sort_by(&:name_kana).each_with_index do |friend, index|
      friend.update_attributes!(number: index)
    end

    redirect_to friends_path
  end

  private

  def load_friends
    @friends = current_user.friends.name_kana_order
  end

  def load_friend
    @friend = current_user.friends.find_by_id(params[:id])
  end
end
