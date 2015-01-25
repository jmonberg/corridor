class FeedArticle < ActiveRecord::Base
  # Child of the Feed class.
  belongs_to :feed
  has_many :totem_events, :as => :action, :dependent => :destroy

  # Parent to Comments.  Destroy all related Feed Articles Comments upon deletion.
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  has_many :taggs, :as => :taggable, :dependent => :destroy

  # Required field (3)
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :date_posted

  # Requires a relationship with an existing Feed.
  validates_associated :feed

  def comments_enabled?
    true
  end

  # Add an entry to the Totem Event model after adding a new Feed Article.
  def after_create
    totem_events.create(:body => content, :author => feed.site_name, :title => title)
  end
end