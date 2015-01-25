# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # The following are required by AuthLogic
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :redirect_to_org_domain
  # before_filter :store_location

  private

    def banner_url
      @image_urls ||= ['/images/banner_home.jpg']
      @image_urls[rand(@image_urls.length)]
    end

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    #populate array of associated images by tag
    def fetch_images(taggs)
      result = []
      for tag in taggs
        Tagg.all(:conditions => {:taggable_type => 'Image', :title => tag.title}).each do |image|
          result << image.taggable unless result.include?(image.taggable)
        end
      end
      result
    end

    def report_abuse(object)
      # Look for an existing abuse report, increment the counter field.
      # If the reporting user is logged in, fill in the reporting user id, unless it's already filled in.
      # Set the object's suspension_status to 'reported', if it's nil.
      # Then, update the page to let the user know we've recorded their abuse report.
      unless object.suspension_status == 'cleared' 
        abuse = object.abuses[0] ||= object.abuses.new
        abuse.abuse_count += 1
        if current_user
          abuse.reporting_user ||= current_user 
        end
        abuse.save

        # 5 possible status values: nil, reported, under review, cleared, suspended
        if object.suspension_status == nil
          object.suspension_status = 'reported'
          object.save
        end

        respond_to do |format|
          format.html { redirect_to(@article) }
          format.xml  { head :ok }
          format.js { render :update do |page|
              class_name = object.class.to_s.downcase
              div_name = "report_abuse_#{class_name}_#{object.id.to_s}"
              page.replace_html div_name, "Thank you.  This #{class_name.capitalize} will be reported to the moderator."
              page.visual_effect :highlight, div_name, :duration => 3
            end
          }
        end
      end
    end

    # Make sure we have a logged-in user who has the appropriate role to be a Admin
    def require_admin
      unless (current_user && current_user.admin?)
        flash[:notice] = "You must log in as an admin to review *something*."
        redirect_to root_path
        return false
      end
    end

    # Make sure we have a logged-in user who has the appropriate role to be a moderator
    def require_moderator
      unless (current_user && current_user.moderator?)
        flash[:notice] = "You must log in as a moderator to review reports of abuse."
        redirect_to root_path
        return false
      end
    end

    def require_user
      unless current_user
        store_location 
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_path
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_path
        return false
      end
    end
    
    def redirect_to_org_domain
      redirect_to "http://ourmichiganave.org#{request.path}" unless (request.domain == "ourmichiganave.org" || RAILS_ENV=="development")
    end

    def store_location
      # session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '95ff8537c8bb2234a0d5b544283c432c'

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
end