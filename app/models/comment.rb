class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  has_many :totem_events, :as => :action, :dependent => :destroy
  has_many :abuses,       :as => :abused, :dependent => :destroy, :class_name => 'Abuse'

  validates_associated :user

  def after_create
    totem_events.create(:body => body, :author => user)
  end

  def title
    return body
  end
end