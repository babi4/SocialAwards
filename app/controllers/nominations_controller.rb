class NominationsController < ApplicationController  
  def index
    @nominations = Nomination.all
  end
end
