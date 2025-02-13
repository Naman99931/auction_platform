class PaymentsController < ApplicationController
  def create
    @item = Item.find(params[:id])

    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: "inr",
          product_data: {
            name: @item.title
          },
          unit_amount: (@item.current_price * 100).to_i
        },
        quantity: 1
      }],
      mode: 'payment',
      # success_url: "#{root_url}success",
      success_url: "#{root_url}success?session_id={CHECKOUT_SESSION_ID}&item_id=#{@item.id}",

      cancel_url: "#{root_url}cancel"
    })

    respond_to do |format|
      format.html { redirect_to @session.url, allow_other_host: true } 
      format.js 
    end
    
  end

  def success
    session_id = params[:session_id]
    item_id = params[:item_id]

    @item = Item.find_by(id: item_id)

    if @item
      @item.update_column(payment_status: "done") 
      @user = User.find_by(id: @item.winner_id) 
      UserMailer.payment_success(current_user).deliver_later
    end
  end
end
