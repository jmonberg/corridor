class Article < ActiveRecord::Base

  # Create named scopes for filtering articles.  (Requires Rails 2.3.2)
  # Active:    All Articles that have *NOT* been suspended.
  # Suspended: Suspended articles only.
  named_scope :active,    :conditions => { :suspended_at => nil }
  named_scope :suspended, :conditions => [ "suspended_at > ?", 1]

  # Each Article should be associated with a registered User.
  belongs_to :user
  has_many :votes
  has_many :totem_events, :as => :action,       :dependent => :destroy
  has_many :comments,     :as => :commentable,  :dependent => :destroy
  has_many :taggs,        :as => :taggable,     :dependent => :destroy
  has_many :abuses,       :as => :abused,       :dependent => :destroy, :class_name => 'Abuse'
  has_many :maps
  validates_presence_of :title, :body, :category
  validates_associated :user, :on => :create

  def after_create
    totem_events.create(:body => body, :author => user.display_name, :title => title)
  end
  
  def votes_count
    votes.length
  end
end
