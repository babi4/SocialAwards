class NominationsController < ApplicationController  

  before_filter :find_nomination, :only => :show
  respond_to :html, :json

  def index
    @nominations = Nomination.all
    respond_with @nominations
  end

  def show
    @nomination_hash = @nomination.get_hash_with_nominees()
    respond_with :nomination => @nomination_hash
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
  end

end
