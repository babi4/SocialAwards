class NominationsController < ApplicationController  

  before_filter :find_nomination, :only => :show
  after_filter :get_current_user_info
  respond_to :html, :json

  def index
    @nominations = Nomination.all
    respond_to do |format|
      format.html do
        @user = get_current_user_info
      end
      format.json {render :json => @nominations}
    end
  end

  def show
    nominees_hash = @nomination.get_nominees_hash
    nomination_hash = @nomination.serializable_hash.merge :nominees => nominees_hash.keys
    respond_to do |format|
      format.html do
        @user = get_current_user_info
      end
      format.json {render :json => {:nomination => nomination_hash, :nominees => nominees_hash.values} }
    end
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
  end

  def get_current_user_info
    current_user ? current_user.to_json : false
  end

end
