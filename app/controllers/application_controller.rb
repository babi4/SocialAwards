class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_400(text=nil)
    if text.nil?
      render :nothing => true, :status => 400
    else
      render :text => text, :status => 400
    end
  end

  def renderOK(data={})
    render :json => {:error => false}.merge(data)
  end

  def renderErr(message="Ooops. Something is going wrong")
    render :json => {:error => message}
  end

  
end
