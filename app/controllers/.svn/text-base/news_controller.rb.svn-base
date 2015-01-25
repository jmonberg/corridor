class NewsController < ApplicationController
  def index
    # Collect all the Feed Articles posted in the last 1 month, with the newest articles first.
    @feed_articles = FeedArticle.paginate(:per_page => 5, 
                                          :page => params[:page],
                                          :conditions => ['date_posted >= ?', (Date.today - 1.months)], 
                                          :order => "date_posted DESC")
  end
end