class NominationsController < ApplicationController  

  before_filter :find_nomination, :only => :show
  respond_to :html, :json

  def index
    @nominations = Nomination.all
    respond_with @nominations
  end

  def show
    nominees_hash = @nomination.get_nominees_hash
#    @nomination_hash = @nominatio
    nomination_hash = @nomination.serializable_hash.merge :nominees => nominees_hash.keys
    respond_with :nomination => nomination_hash, :nominees => nominees_hash.values 
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
  end

end
