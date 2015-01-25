class FeedArticlesController < ApplicationController

  def index
    @feed_articles = FeedArticle.paginate(:conditions => {:feed_id => params[:feed_id]},
                                          :per_page => 2, 
                                          :page => params[:page])
  end

  def show
    if !params['feed_id']
      @feed_article = FeedArticle.find(params[:id])
      redirect_to [@feed_article.feed, @feed_article]
    else
      @feed_article = Feed.find(params[:feed_id]).feed_articles.find(params[:id])
      @images = fetch_images(@feed_article.taggs)
    end
  end
end