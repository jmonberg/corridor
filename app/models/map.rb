class Map < ActiveRecord::Base
  belongs_to :user
  has_many :taggs, :as => :taggable, :dependent => :destroy
  validates_presence_of :latitude, :longitude, :category, :comment, :user_id
  validates_length_of :comment, :maximum=>255
  has_many :comments,     :as => :commentable,  :dependent => :destroy
  belongs_to :articles
  
  def title
    comment
  end
end
