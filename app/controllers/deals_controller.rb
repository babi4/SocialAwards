class DealsController < ApplicationController

  before_filter :find_deal, :only => :check

  def index
    deals = Deal.all
    render :json => deals
  end

  def check
    DaemonConnector.send_to_deal_check :target => @deal.target, :user => {:id => current_user.id, :token => current_user.token}
    renderOK
  end

  private

  def find_deal
    @deal = Deal.find params[:id]
  end

end
