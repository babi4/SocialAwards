class DealsController < ApplicationController

  before_filter :find_deal, :only => [:check, :report]

  def index
    deals = Deal.all
    render :json => deals
  end

  def check
    DaemonConnector.send_to_deal_check({
      :target => {:uid => @deal.target.uid, :type => @deal.target_type }, 
      :user => {:id => current_user.id, :uid => current_user.uid, :token => current_user.token},
      :deal_id => @deal.id,
      :action_type => @deal.action_type })
    renderOK
  end

  def report
    #TODO check daemon token
    if params[:status] == true
      #save to db 
    else
      #notify false
      message = FayeMessage.new :user_notify, :user_id => params[:user_id], :action => :deal_check, :status => :failed, :deal_id => @deal.id
      message.send
    end
    renderOK
  end

  private

  def find_deal
    @deal = Deal.find params[:id]
  end

end
