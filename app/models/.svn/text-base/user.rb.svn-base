class User < ActiveRecord::Base
  # Authentication
  acts_as_authentic

  # Validation
  validates_uniqueness_of :display_name

  # Each registered User can have (submit) many Articles, Comments, Images, or Stories. 
  has_many :articles
  has_many :comments
  has_many :images
  has_many :stories

  def moderator?
    (role == 2) || admin?
  end

  def admin?
    role == 3
  end

end