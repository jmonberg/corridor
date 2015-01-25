class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  def cooperation
    # Set the variable for the desired Category.
    @category = "Cooperation"
    # Call the protected method to display the Articles for that Category
    fetch_articles( @category )
  end

  def environmental
    # Set the variable for the desired Category.
    @category = "Environmental Sustainability"
    # Call the protected method to display the Articles for that Category
    fetch_articles( @category )
  end

  def business
    # Set the variable for the desired Category.
    @category = "Business Development"
    # Call the protected method to display the Articles for that Category
    fetch_articles( @category )
  end

  def transportation
    # Set the variable for the desired Category.
    @category = "Transportation"
    # Call the protected method to display the Articles for that Category
    fetch_articles( @category )
  end

  def streetscape
    # Set the variable for the desired Category.
    @category = "Streetscape"
    # Call the protected method to display the Articles for that Category
    fetch_articles( @category )
  end

  def densemixeduse
    # Set the variable for the desired Category.
    @category = "Dense Mixed Use"
    # Call the protected method to display the Articles for that Category
    fetch_articles( @category )
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
	  @article = Article.find(params[:id])
    @positivevotes = @article.votes.find_all_by_positive(true) # get an array of "Yes" votes
    unless @positivevotes  # if there are no positive votes
      @positivevotes = Array.new # make an empty array so we don't get an error
    end
    if session[:previousvotes] # if the session is set already
      # checks to see if the :previousvotes session array contains this article's id (as a string)
      @hidevotebuttons = session[:previousvotes].include?(@article.id.to_s) 
    else
      session[:previousvotes] = Array.new
    end

    @images = fetch_images(@article.taggs)
    @mapz0r = Map.find_by_ref_id_and_category(@article.id, 'article')

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.xml
  def create
    # Create a new article object from hash
    @article = Article.new(params[:article])
    # Add the User ID to the hash
    @article.user = current_user
    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        tweet_this( @article )
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1/abuse
  def abuse
    # Pass the object to the abuse reporting method
    report_abuse Article.find(params[:id])
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end

  protected
  # Create a central, shared method to collect and display Articles from different Categories  (Doug Maier)
  def fetch_articles(fetch_category)
    # NOTE: Present 5 articles per page, highest votes first, by the selected Category.
    @articles = Article.active.paginate :per_page => 5,
                                        :page => params[:page],
                                        :order => 'votes_count DESC',
                                        :conditions => "category = '" + fetch_category + "'"

    respond_to do |format|
      format.html { render :action => 'show_articles' }
      format.xml  { render :xml => @article }
    end
  end
  
  # Create a twitter post to MichiganAve when a new article is successfully created.
  def tweet_this(article)
    # We have a limit of 140 characters, so long titles might get cut off.
    @tweetcontent = "#{article.user.display_name} has a new #{article.category} idea at www.ourmichiganave.org/articles/#{article.id} : \"#{article.title}\"" # a bit convoluted, but it works
    @username = "michiganave"
    @password = "t3stingtw1tter"
    api_url = 'http://twitter.com/statuses/update.xml'
    url = URI.parse(api_url)
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth(@username, @password)
    req.set_form_data({ 'status'=> @tweetcontent }, ';')
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    return res
  end
end