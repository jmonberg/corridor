class AbusesController < ApplicationController
  # Only moderators (or higher) can view, edit, update, or delete an abuse report.
  before_filter :require_moderator, :only => [:index, :edit, :show, :update, :delete]


  def set_abuse_partial
    # Determines which partial to display 
    case @abuse.abused_type
      when 'Article', 'Comment', 'Story' then
        @partial_name = "abuse_#{@abuse.abused_type.downcase}"
      else
        @partial_name = nil
    end
  end

  def set_moderator_name
    if @abuse.moderator_id.nil?
      @moderator_name = nil
    else
      @moderator_name = @abuse.moderator.display_name
    end
  end

  # GET /abuses
  # GET /abuses.xml
  def index
    @abuses = Abuse.paginate :per_page => 3, 
                             :page => params[:page], 
                             :order => 'abuse_count DESC'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @abuses }
    end
  end

  # GET /abuses/1
  # GET /abuses/1.xml
  def show
    @abuse = Abuse.find(params[:id])
    set_abuse_partial
    set_moderator_name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @abuse }
    end
  end

  # GET /abuses/new
  # GET /abuses/new.xml
  def new
    @abuse = Abuse.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @abuse }
    end
  end

  # GET /abuses/1/edit
  def edit
    @abuse = Abuse.find(params[:id])
    set_abuse_partial
    set_moderator_name
  end

  # POST /abuses
  # POST /abuses.xml
  def create
    @abuse = Abuse.new(params[:abuse])

    respond_to do |format|
      if @abuse.save
        flash[:notice] = 'Abuse was successfully created.'
        format.html { redirect_to(@abuse) }
        format.xml  { render :xml => @abuse, :status => :created, :location => @abuse }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @abuse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /abuses/1
  # PUT /abuses/1.xml
  def update
    @abuse = Abuse.find(params[:id])
    @abuse.moderator_id = current_user.id

    respond_to do |format|
      if @abuse.update_attributes(params[:abuse])
        flash[:notice] = 'Abuse was successfully updated.'
        format.html { redirect_to(@abuse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @abuse.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /abuses/1
  # DELETE /abuses/1.xml
  def destroy
    @abuse = Abuse.find(params[:id])
    @abuse.destroy

    respond_to do |format|
      format.html { redirect_to(abuses_url) }
      format.xml  { head :ok }
    end
  end
end