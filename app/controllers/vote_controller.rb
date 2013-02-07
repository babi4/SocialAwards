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
    
  end


  def find_user
    
  end

  def find_nominee
    
  end

  def get_score
    
  end


end
