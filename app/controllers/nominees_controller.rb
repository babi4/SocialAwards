class NomineesController < ApplicationController

  before_filter :find_nominee, :only => [:show]
  before_filter :get_uid_and_nomination, :only => [:create]

  def show
    nominations = Nomination.find_nominatios_with_nominee_json @nominee.screen_name, @nominee.id
    @nominee_json = @nominee.serializable_hash.merge :nominations => nominations
  end


  def create
    nominee_model = get_nominee_model
    nominee = nominee_model.where(:uid => @uid).try :first
    unless nominee
        nominee = nominee_model.create_by_uid @uid
    end
    if nominee
      nominee_score = @nomination.get_nominee_score nominee.id
      if nominee_score
        renderOK :status => 'already_nominated'
      else
        score = @nomination.nominate nominee
        renderOK :status => 'nominated', :nominee => nominee.serializable_hash.merge(:score => score)
      end
    else
      renderErr "Can't find/create nominee"
    end
  end


  private
  def find_nominee
    unless params[:id]      
      render_400 "Missing params" 
    else
      screen_name = params[:id]
      type = $redis.hget 'nominee_to_type', screen_name
      puts type
      if type == 'user'
        nominee_class = User
        @nominee = nominee_class.find_by_screen_name screen_name
      else
        render_400 "Cant find such nominee"
      end
    end
  end

  def get_nominee_model
    case @nomination.nominees_type
    when 'user' #TODO rename to person
      Person
    when 'public'
      Public
    end
  end

  def get_uid_and_nomination
    puts params
    if params[:uid] and params[:nomination_id]
      @uid =  params[:uid]
      @nomination = Nomination.find(params[:nomination_id])
    else
      render_400 "Missing params"
    end
  end

end
