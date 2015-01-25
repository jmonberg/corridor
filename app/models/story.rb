class Story < ActiveRecord::Base
  # Filter out the suspended articles.              (Requires Rails 2.3.2)
  default_scope           :conditions => { :suspended_at => nil }
  # Filter *in* the suspended articles              (Requires Rails 2.3.2)
  named_scope :suspended, :conditions => 'suspended_at > 0'
  # Include *all* articles, suspended or otherwise  (Requires Rails 2.3.2)
  named_scope :all,       :conditions => nil

  belongs_to :user
  has_many   :totem_events, :as => :action,   :dependent => :destroy
  has_many   :taggs,        :as => :taggable, :dependent => :destroy
  has_many   :abuses,       :as => :abused,   :dependent => :destroy, :class_name => 'Abuse'
  has_many :maps
  validates_presence_of :title, :body

  def after_create
    totem_events.create(:body => "has posted a story", :author => user.display_name, :title => title)
    @plogged = true # so the event is only logged in the plog once on creation
  end

  def after_save
    unless @plogged
      totem_events.each(&:delete)
      totem_events.create(:body => "'s story has been updated", :author => user.display_name, :title => title)
    end
  end
end