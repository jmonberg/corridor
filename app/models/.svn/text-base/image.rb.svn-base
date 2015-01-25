class Image < ActiveRecord::Base
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :taggs, :as => :taggable, :dependent => :destroy
  belongs_to :user
  has_many :totem_events, :as => :action, :dependent => :destroy
  
  has_attached_file :photo, :styles => {:big => "640x480>", :thumbnail => "120x120>"}
  
                    
  validates_attachment_presence :photo
  validates_presence_of :title
  
  def after_create
    totem_events.create(:author => user.display_name, :title => title)
  end
  
  # def taggs=(tagg_string)
  # end
end
