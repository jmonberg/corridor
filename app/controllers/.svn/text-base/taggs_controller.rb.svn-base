class TaggsController < ApplicationController
  # GET /taggs
  # GET /taggs.xml
  def index
    @taggs = Tagg.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taggs }
    end
  end

  # GET /taggs/1
  # GET /taggs/1.xml
  def show
    @tagg = Tagg.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tagg }
    end
  end

  # GET /taggs/new
  # GET /taggs/new.xml
  def new
    @tagg = Tagg.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tagg }
    end
  end

  # GET /taggs/1/edit
  def edit
    @tagg = Tagg.find(params[:id])
  end

  # POST /taggs
  # POST /taggs.xml
  def create
    @tagg = Tagg.new(params[:tagg])
    @tagg.taggable = find_taggable
    unless @tagg.user = current_user
      flash[:notice] = "You must be logged in to create tags"
      redirect_to @tagg.taggable
      return
    end
    respond_to do |format|
      if @tagg.save
        flash[:notice] = 'Tagg was successfully created.'
        format.html { redirect_to(@tagg.taggable) }
        format.xml  { render :xml => @tagg, :status => :created, :location => @tagg }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tagg.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /taggs/1
  # PUT /taggs/1.xml
  def update
    @tagg = Tagg.find(params[:id])

    respond_to do |format|
      if @tagg.update_attributes(params[:tagg])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(@tagg) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tagg.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taggs/1
  # DELETE /taggs/1.xml
  def destroy
    @tagg = Tagg.find(params[:id])
    @taggable = @tagg.taggable
    if @tagg.user == current_user || @tagg.taggable.user == current_user || current_user.moderator?
      @tagg.destroy

      respond_to do |format|
        format.html { redirect_to(@taggable) }
        format.xml  { head :ok }
      end
    else
      flash[:notice] = "Only authors of the article or tag can delete tags."
      redirect_to @tagg.taggable
    end
  end
  
  def search
    if params[:term] && params[:term] != ''
      @taggs = Tagg.all(:conditions => ["title LIKE ?", params[:term]])
    else
      @taggs = []
    end
  end
  
  private
  def find_taggable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
