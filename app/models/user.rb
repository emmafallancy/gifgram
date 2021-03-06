# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :text
#  name            :text
#  email           :text
#  profile_img     :text
#  biography       :text
#  password_digest :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password
  has_many :posts, dependent: :destroy
  has_many :comments

  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy

  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy

  has_many :follower, :through => :active_relationships, source: :followed
  has_many :followed, :through => :passive_relationships, source: :follower

  # Follow a user
  def follow( other_user )
    active_relationships.create( :followed_id => other_user.id )
  end

  # Unfollow a user
  def unfollow( other_user )
    binding.pry
    active_relationships.find_by( :followed_id => other_user.id ).destroy
  end

  def following?( other_user )
    followed.include?( other_user )
  end
end
