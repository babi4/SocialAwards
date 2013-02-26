class DealsController < ApplicationController

  before_filter :find_deal, :only => :check

  def index
    deals = Deal.all
    render :json => deals
  end

  def check

    DaemonConnector.send_to_deal_check({
      :target => {:uid => @deal.target.uid, :type => @deal.target_type }, 
      :user => {:id => current_user.id, :uid => current_user.uid, :token => current_user.token}, 
      :action_type => @deal.action_type })
    renderOK
  end

  private

  def find_deal
    @deal = Deal.find params[:id]
  end

end
