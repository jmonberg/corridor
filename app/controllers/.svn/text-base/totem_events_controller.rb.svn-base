class TotemEventsController < ApplicationController
  # GET /totem_events
  # GET /totem_events.xml
  def index
    @totem_events = TotemEvent.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @totem_events }
    end
  end

  # GET /totem_events/1
  # GET /totem_events/1.xml
  def show
    @totem_event = TotemEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @totem_event }
    end
  end

  # GET /totem_events/new
  # GET /totem_events/new.xml
  def new
    @totem_event = TotemEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @totem_event }
    end
  end

  # GET /totem_events/1/edit
  def edit
    @totem_event = TotemEvent.find(params[:id])
  end

  # POST /totem_events
  # POST /totem_events.xml
  def create
    @totem_event = TotemEvent.new(params[:totem_event])

    respond_to do |format|
      if @totem_event.save
        flash[:notice] = 'TotemEvent was successfully created.'
        format.html { redirect_to(@totem_event) }
        format.xml  { render :xml => @totem_event, :status => :created, :location => @totem_event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @totem_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /totem_events/1
  # PUT /totem_events/1.xml
  def update
    @totem_event = TotemEvent.find(params[:id])

    respond_to do |format|
      if @totem_event.update_attributes(params[:totem_event])
        flash[:notice] = 'TotemEvent was successfully updated.'
        format.html { redirect_to(@totem_event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @totem_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /totem_events/1
  # DELETE /totem_events/1.xml
  def destroy
    @totem_event = TotemEvent.find(params[:id])
    @totem_event.destroy

    respond_to do |format|
      format.html { redirect_to(totem_events_url) }
      format.xml  { head :ok }
    end
  end
end
