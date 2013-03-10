class DealsController < ApplicationController

  before_filter :find_deal, :only => [:check, :report]
  before_filter :find_user, :only => [:report, :cancel]

  def index
    #TODO maybe use some arel magick?
    suc_user_deals_ids = current_user.success_user_deals.to_a.map(&:deal_id)

    puts suc_user_deals_ids.inspect

    deals_table = Deal.arel_table

    if suc_user_deals_ids.empty?
      deals = Deal.all
    else
      deals = Deal.where deals_table[:id].not_in suc_user_deals_ids
    end
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
    if params[:status] == "true"
      s_deal_id = SuccessUserDeal.create :user => @user, :deal => @deal
      message = FayeMessage.new :user_notify, :user_id => params[:user_id], :action => :deal_check, :status => :success, :deal_id => @deal.id, :s_deal_id => s_deal_id.id
      message.send
    else
      #notify false
      message = FayeMessage.new :user_notify, :user_id => params[:user_id], :action => :deal_check, :status => :failed, :deal_id => @deal.id
      message.send
    end
    renderOK
  end
  
  private

  def find_user
    @user = User.find params[:user_id]
  end

  def find_deal
    @deal = Deal.find params[:id]
  end

end
