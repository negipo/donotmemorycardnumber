class Friend < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :name_kana, :picture_url
  validates_uniqueness_of :number, scope: :user_id, allow_nil: true

  before_validation :set_name_kana
  before_validation :resolve_number_collision

  scope :name_kana_order, -> { order('name_kana') }
  scope :has_number, -> { where.not(number: nil) }

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

  def resolve_number_collision
    return unless number

    relation = self.user.friends.where(number: self.number)
    relation.first.update_attributes!(number: nil) if relation.exists?
  end

  def set_name_kana
    self.name_kana = self.name.split(' ').reverse.map(&:kana).join(' ')
  end
end
