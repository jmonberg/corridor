class ImagesController < ApplicationController
  # GET /images
  # GET /images.xml
  def index
    @images = Image.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @images }
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/new
  # GET /images/new.xml
  def new
    require_user
    @image = Image.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.xml
  def create
    require_user
    @image = current_user.images.new(params[:image])
    if params[:tags] != ""
      respond_to do |format|
        if @image.save
          flash[:notice] = 'Image was successfully created.'
          
          tags = params[:tags].split(", ")
          tags.each do |tag|
            @image.taggs.create(:title => tag, :user => current_user)
          end
          
          format.html { redirect_to(@image) }
          format.xml  { render :xml => @image, :status => :created, :location => @image }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:warning] = "Please enter at least one tag for this image."
      render :action => 'new'
    end
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        flash[:notice] = 'Image was successfully updated.'
        format.html { redirect_to(@image) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to(images_url) }
      format.xml  { head :ok }
    end
  end
  
  def categories
    @categories = []
    @images = Hash.new
    for category in @categories
      @images[category] = Tagg.all(:conditions => {:title => category, :taggable_type => 'Image'})
      CompositeImage.new(@images[category].collect{|i| i.taggable}, "#{RAILS_ROOT}/public/images/temp/#{category}.jpg").create_tall_image
    end
  end

end
