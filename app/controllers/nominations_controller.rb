class NominationsController < ApplicationController  

  before_filter :find_nomination, :only => :show

  def index
    @nominations = Nomination.all
  end

  def show
    @nomination
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
    @nomination_hash = @nomination.get_hash_with_nominees()

  end

end
