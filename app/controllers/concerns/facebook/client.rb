class Facebook::Client
  def initialize(token)
    @facebook = Koala::Facebook::API.new(token)
  end

  def friends
    @facebook.get_connections('me', 'taggable_friends')
  end
end
