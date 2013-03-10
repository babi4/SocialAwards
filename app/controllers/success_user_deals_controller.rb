class SuccessUserDealsController < ApplicationController

  before_filter :find_deal, :only => [:destroy]

  def create
  end

  def destroy
    message = FayeMessage.new :user_notify, 
      :user_id   => @deal.user_id,
      :action    => :cancel_deal,
      :s_deal_id => @deal.id

    @deal.destroy
    message.send

  end

  private
  def find_deal
    @deal = SuccessUserDeal.find params[:id]
  end
end



