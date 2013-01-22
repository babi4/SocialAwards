class NominationsController < ApplicationController  

  before_filter :find_nomination, :only => :show

  def index
    @nominations = Nomination.all
  end

  def show
    
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
  end

end
