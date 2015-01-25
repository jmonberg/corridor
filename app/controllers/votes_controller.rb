class VotesController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    # debugger
    if (params[:commit] == "Yes")
      @article.votes.create(:positive => true)
    else
      @article.votes.create(:positive => false)
    end
    @positivevotes = @article.votes.find_all_by_positive(true) || []
    session[:previousvotes] << @article.id.to_s # adds the article's ID to the :previousvotes session array
    
    respond_to do |format|
      format.html { redirect_to @article }
      format.xml  { render :xml => @article }
    end
  end
 
end