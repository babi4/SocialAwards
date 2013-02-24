class DealsController < ApplicationController

  before_filter :find_deal, :only => :check

  def index
    deals = Deal.all
    render :json => deals
  end

  def check
    $daemon_connector
    renderOK
  end

  private

  def find_deal
    @deal = Deal.find params[:id]
  end

end
