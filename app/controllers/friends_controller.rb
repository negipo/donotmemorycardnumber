class FriendsController < ApplicationController
  before_action :load_friends
  before_action :load_friend, only: %i(show update assign_number withdraw_number)

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
    @friends.update_all(number: nil)
    @friends.sample(100).sort_by(&:name_kana).each_with_index do |friend, index|
      friend.update_attributes!(number: index)
    end

    redirect_to friends_path
  end

  def assign_number
    friends_has_number = (@friends.has_number.all + [@friend]).uniq.sort_by(&:name_kana)
    Friend.assign_numbers(current_user, friends_has_number)

    redirect_to friends_path(anchor: "friend_#{@friend.id}")
  end

  def withdraw_number
    friends_has_number = @friends.has_number.where.not(id: @friend.id).to_a
    Friend.assign_numbers(current_user, friends_has_number)

    redirect_to friends_path(anchor: "friend_#{@friend.id}")
  end

  private

  def load_friends
    @friends = current_user.friends.name_kana_order
  end

  def load_friend
    @friend = current_user.friends.find_by_id(params[:id])
  end
end
