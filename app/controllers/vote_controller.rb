class VoteController < ApplicationController
  before_action :find_award
  before_action :find_nomination
  before_action :find_user
  before_action :find_nominee
  before_action :get_score

  def create

  end

  def find_award
    @award = Award.get_current
  end

  def find_nomination
    @find_nomination = Nomination.find params[:nomination_id]
  end


  def find_user
    if current_user
      current_user
    else
      renderErr "Log in plz"
    end
  end

  def find_nominee
    
  end

  def get_score
    
  end


end
