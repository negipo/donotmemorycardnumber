class Friend < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :name_kana, :picture_url

  before_validation :set_name_kana

  def self.build_with_user(user, raw_friends)
    raw_friends.each do |raw_friend|
      record = self.new(
        user: user,
        name: raw_friend['name'],
        picture_url: raw_friend['picture']['data']['url']
      )
      record.save!
    end
  end

  private

  def set_name_kana
    self.name_kana = self.name.split(' ').reverse.map(&:kana).join(' ')
  end
end
