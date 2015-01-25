class PlogController < ApplicationController
  def index
    if params[:type] && params[:type] != ''
      @totem_events = TotemEvent.paginate :per_page => 10, 
                                          :page => params[:page], 
                                          :conditions => ["action_type LIKE ?", params[:type]],
                                          :order => 'created_at DESC'
    else
      @totem_events = TotemEvent.paginate :per_page => 10, 
                                          :page => params[:page],
                                          :order => 'created_at DESC'
    end
  end
end