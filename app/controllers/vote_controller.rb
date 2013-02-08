class VoteController < ApplicationController
  before_filter :find_award
  before_filter :find_nomination
  before_filter :find_user
  before_filter :find_nominee
  before_filter :get_score

  def create
    #TODO think about votes save
    new_score = @nomination.add_score @nominee, @vote_score
    if new_score
      Vote.create({
        :award_id => @award.id,
        :nomination => @nomination,
        :user_id  => current_user.id,
        :nominee => @nominee,
        :score => @vote_score
      })
      renderOK :new_score => new_score
    else
      renderErr "failed to vote"
    end
  end

  def find_award
    @award = Award.get_current
  end

  def find_nomination
    @nomination = Nomination.find params[:nomination_id]
  end


  def find_user
    if current_user
      current_user
    else
      renderErr "Log in plz"
    end
  end

  def find_nominee
    @nominee = @nomination.nominee_model.find params[:nominee_id]
  end

  def get_score
    #TODO check vote score
    @vote_score = params[:vote_score] 
    renderErr "vote_score required " unless @vote_score 
  end


end
