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
    nominees_and_scores_hash = @nomination.get_nominees_hash
    nomination_hash = @nomination.serializable_hash.merge :nominees_scores => []

 #   nominees_h = {}
 #   nominees_and_scores_hash[:nominees].each do |nominee|
 #     nominees_h[nominee.id] = nominee.serializable_hash.merge(:nominees_scores => [])
  #  end
  # 
    seed = rand 100000
    i = 0
    nominees_scores = []
    nominees_and_scores_hash[:scores].each do |score_a|
      s_id = seed + i
      score_h = {
        :id         => s_id,
        :nominee_id => score_a.first.to_i,
        :score      => score_a.last.to_i
      }
      nominees_scores << score_h
      nomination_hash[:nominees_scores] << s_id
      i+=1
    end


    response = {:nomination => nomination_hash, :nominees_scores => nominees_scores }
    if @nomination.nominee_model == Person 
      response['peoples'] = nominees_and_scores_hash[:nominees]
    else
      throw "EXECPTION"
    end  

    respond_to do |format|
      format.html do
        @nomination_info = response.to_json
        @user = get_current_user_info
      end
      format.json {render :json => response }
    end
  end


  def find_nomination
    @nomination = Nomination.find params[:id]
  end

  def get_current_user_info
    current_user ? current_user.to_json : false
  end

end
