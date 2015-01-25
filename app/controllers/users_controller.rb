class UsersController < ApplicationController
  # Only users who aren't logged in can create or save a new user.
  before_filter :require_no_user, :only => [:new, :create]

  # Only logged in users can view, edit, or update their own info
  #before_filter :require_user, :only => [:show, :edit, :update]

  # Only logged in users can edit, or update their own info
  before_filter :require_user, :only => [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def show
    # Let's look at the current user's profile.
    # NOTE: This is OK if we only let people look at their own profile, but
    # this doesn't work if we want to allow people to look at anybody's profile.
    #@user = @current_user

    # Let's look at the user profile specified by the ID parameter
    @user     = User.find(params[:id] || current_user)
    @articles = Article.paginate :per_page => 3,
                                 :page => params[:page],
                                 :conditions => 'user_id = ' + @user.id.to_s,
                                 :order => "updated_at DESC"

    @stories = Story.paginate    :per_page => 3, 
                                 :page => params[:page],
                                 :conditions => 'user_id = ' + @user.id.to_s,
                                 :order => "updated_at DESC"
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  protected
  def moderator?
    (role == 2) || admin?
  end

  def admin
    role == 3
  end
end