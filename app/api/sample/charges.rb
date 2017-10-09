class Sample::Charges < Grape::API

  require "stripe"
  Stripe.api_key = ENV["STRIPE_API_KEY"]
  Stripe.api_version = "2016-07-06"

  before do
    authenticate_user!
  end

  resource "charges" do

    desc "return all Charges"
    get '/all' do
      # TODO: test用
      result = Charge.all
      present :charges, result, with: Sample::Entities::Charge, user: current_user
    end

    desc "return a Latest Charge"
    get '/latest' do
      result = current_user.charges.last
      present :charges, result, with: Sample::Entities::Charge, user: current_user
    end

    desc "return a Latest Charge params[:count] rows"
    params do
      requires :count, type: Integer, desc: "row count"
    end
    get '/latest/:count' do
      result = current_user.charges.last(params[:count])
      present :charges, result, with: Sample::Entities::Charge, user: current_user
    end

    # TODO 都度課金プライスリスト
    desc "return a list of Charge Plans"
    get '/price-list' do
    end
    
    desc "create new Charge"
    params do
      requires :amount, type: Integer, desc: "amount (ドル OR 円)"
      requires :currency, type: String, default: 'usd', values: ['usd', 'jpy']
    end
    post do
      error!('not subscribed', 400) if !current_user.subscribed?  # [MUST]メンバーシップ加入済み

      amount = params[:amount] * 100 if params[:currency] == 'usd'
      amount = params[:amount]       if params[:currency] == 'jpy'

      customer  = current_user.customer
      charge    = Stripe::Charge.create(
        customer:    customer,
        currency:    params[:currency],
        amount:      amount,
        description: "Charge for #{current_user.email}",
      )

      charges = current_user.charges.create({
        stripe_charge_id:       charge.id,
        amount:                 charge.amount,
        currency:               charge.currency,
      })
      charges.save

      present :charges, charges, with: Sample::Entities::Charge, user: current_user
    end


  end

end
