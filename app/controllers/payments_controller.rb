class PaymentsController < ApplicationController
  def create
    item = Item.find(params[:id])

    @session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: "inr",
          product_data: {
            name: item.title
          },
          unit_amount: (item.current_price * 100).to_i
        },
        quantity: 1
      }],
      mode: 'payment',
      success_url: "#{root_url}success",
      cancel_url: "#{root_url}cancel"
    })

    respond_to do |format|
      format.html { redirect_to @session.url, allow_other_host: true } 
      format.js 
    end
    
  end
end
