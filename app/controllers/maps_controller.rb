class MapsController < ApplicationController
  # GET /maps
  # GET /maps.xml
  def index
    @maps = Map.find(:all)
    @maps_paginate = Map.paginate :per_page => 10, :page => params[:page], :order => "created_at DESC"
    respond_to do |format|
	  format.html 
	  format.xml  { render :text => @maps.to_xml(:root=>"data") }
	end
  end

  def highlight
    # Set the variable for the desired Category.
    @category = "highlight"
    # Call the protected method to display the Articles for that Category
    fetch_maps( @category )
  end
  
  def story
    # Set the variable for the desired Category.
    @category = "story"
    # Call the protected method to display the Articles for that Category
    fetch_maps( @category )
  end
  
  def article
    # Set the variable for the desired Category.
    @category = "article"
    # Call the protected method to display the Articles for that Category
    fetch_maps( @category )
  end
  
  def improvement
    # Set the variable for the desired Category.
    @category = "improvement"
    # Call the protected method to display the Articles for that Category
    fetch_maps( @category )
  end  

  # GET /maps/1
  # GET /maps/1.xml
  def show
    @map = Map.find(params[:id])
	
	respond_to do |format|
	  format.html #
	  format.xml {render :text=>@map.to_xml(:root => "data")}
	end
  end  


  # GET /maps/new
  # GET /maps/new.xml
  def new
    @map = Map.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @map }
    end
  end

  # GET /maps/1/edit
  def edit
    @map = Map.find(params[:id])
	
	respond_to do |format|
	  format.html #
	  format.xml {render :text=>@map.to_xml(:root => "data")}
	end
  end

  # POST /maps
  # POST /maps.xml
  def create
    @map = Map.new(params[:map])

    respond_to do |format|
      if @map.save
        flash[:notice] = 'Map was successfully created.'
        format.html { redirect_to(@map) }
        format.xml  { render :xml => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /maps/1
  # PUT /maps/1.xml
  def update
    @map = Map.find(params[:id])

    respond_to do |format|
      if @map.update_attributes(params[:map])
        flash[:notice] = 'Map was successfully updated.'
        format.html { redirect_to(@map) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /maps/1
  # DELETE /maps/1.xml
  def destroy
    @map = Map.find(params[:id])
    @map.destroy

    respond_to do |format|
      format.html { redirect_to(maps_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  # Create a central, shared method to collect and display Maps from different Categories  (appended from Doug Maier's Article function)
  def fetch_maps(fetch_category)
    # Example: Finds all Maps in the Cooperation category. 
    #          @maps = Map.find(:all, 
    #                                   :conditions => "category = 'experience'"
    @maps = Map.find(:all,:conditions => "category = '" + fetch_category + "'")
    @maps_paginate = Map.paginate :per_page => 10, :page => params[:page], :conditions => "category = '" + fetch_category + "'", :order => "created_at DESC"
    respond_to do |format|
      format.html { render :action => 'show_maps' }
  	  format.xml  { render :text => @maps.to_xml(:root=>"data") }      
    end
  end
end
