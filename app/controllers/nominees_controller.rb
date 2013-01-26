class NomineesController < ApplicationController

  before_filter :find_nominee

  def show
    nominations = Nomination.find_nominatios_with_nominee_json @nominee.screen_name, @nominee.id
    @nominee_json = @nominee.serializable_hash.merge :nominations => nominations
  end


  private
  def find_nominee
    render_400 "Missing params" unless params[:id]
    screen_name = params[:id]
    type = $redis.hget 'nominee_to_type', screen_name
    puts type
    if type == 'user'
      nominee_class = User
    else
      render_400 "Cant find such nominee"
    end
    @nominee = nominee_class.find_by_screen_name screen_name
  end

end
