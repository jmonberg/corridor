class Feed < ActiveRecord::Base
  require 'rss/1.0'
  require 'rss/2.0'
  require 'open-uri'
  require 'rss'

  # Parent to Feed Articles.  Destroy all related Feed Articles upon deletion.
  has_many :feed_articles, :dependent => :destroy

  # Required fields (3)
  validates_presence_of :feed_url
  validates_presence_of :site_name
  validates_presence_of :site_url

  # Reject duplicated Feeds (Feed URL values)
  validates_uniqueness_of :feed_url

  # Data validation
  def validate

    begin
      uri = URI.parse(site_url)
      if uri.class != URI::HTTP
        errors.add(:site_url, 'must be a valid HTTP address')
      end
    rescue URI::InvalidURIError
      errors.add(:site_url, 'has an invalid format')
    end
    begin
      uri = URI.parse(feed_url)
      if uri.class != URI::HTTP
        errors.add(:feed_url, 'must be a valid HTTP address')
      end
    rescue URI::InvalidURIError
      errors.add(:feed_url, 'The format of the url is not valid.')
    end
    begin
      pull :test => true
    rescue SocketError, URI::InvalidURIError
      errors.add(:feed_url, ' - We are unable to interpret the feed from this site. Note that the site is currently compatible with RSS 1.0 and 2.0 feeds, but not Atom.')
    end
  end

  def after_save
    pull
  end

  def pull(options = {:test => false})
    content = ""
    open(feed_url) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)
    raise URI::InvalidURIError unless rss
    rss.items.each do |feed_article|
      unless FeedArticle.find_by_permalink(feed_article.link)
        date = defined?(feed_article.pubDate) ? feed_article.pubDate : feed_article.dc_date
        article = feed_articles.new(:title => feed_article.title, 
                                    :content => feed_article.description, 
                                    :permalink => feed_article.link, 
                                    :date_posted => date.to_datetime)
        article.save unless options[:test]
      end
    end
  end

end