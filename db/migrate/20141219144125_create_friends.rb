class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.string :name
      t.string :name_kana
      t.string :number
      t.string :picture_url

      t.timestamps

      t.index %i(user_id number)
      t.index %i(user_id name_kana)
    end
  end
end
