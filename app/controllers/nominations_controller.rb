class NominationsController < ApplicationController  

  before_filter :find_nomination, :only => :show

  def index
    @nominations = Nomination.all
  end

  def show
    @nomination_hash = @nomination.get_hash_with_nominees()
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
  end

end
