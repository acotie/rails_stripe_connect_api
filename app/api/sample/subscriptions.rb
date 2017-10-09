class Sample::Subscriptions < Grape::API

  require "stripe"
  Stripe.api_key = ENV["STRIPE_API_KEY"]
  Stripe.api_version = "2016-07-06"

  before do
    authenticate_user!
  end

  resource "subscriptions" do

    # TODO: test
    desc "return all Subscription"
    get '/all' do
      result = Subscription.all
      present :subscription, result, with: Sample::Entities::Subscription, user: current_user
    end

    desc "return a Latest Subscription"
    get '/latest' do
      result = current_user.subscription
      present :subscription, result, with: Sample::Entities::Subscription, user: current_user
    end

    desc "return a list of Subscription Plans"
    get '/price-list' do
      result = Stripe::Plan.all
    end

    desc "create new Subscription (old: Add subscription with credit-card)"
    params do
      requires :plan_id, type: String, desc: "stripe plan_id (text)"
      requires :card, type: Hash do
        requires :exp_month, type: Integer, desc: "card exp_month"
        requires :exp_year, type: Integer, desc: "card exp_year"
        requires :number, type: String, desc: "card number"
        requires :cvc, type: String, desc: "card cvc"
        #optional :name, type: String, desc: "card holders full name", default:nil
      end
    end
    post '/old' do
      error!('already subscription', 400) if current_user.subscribed?

      customer = current_user.customer
      customer.plan = params[:plan_id]
      customer.source = {
        object: 'card',
        number:    params[:card][:number],
        exp_month: params[:card][:exp_month],
        exp_year:  params[:card][:exp_year],
        cvc:       params[:card][:cvc]
      }
      customer.save

      # update credit card
      #current_user.save_credit_card(customer.sources.first)

      subscription = current_user.create_subscription({
        stripe_subscription_id: customer.subscriptions.data[0].id,
        stripe_plan_id:         customer.subscriptions.data[0].plan.id,
        amount:                 customer.subscriptions.data[0].plan.amount,
        interval:               customer.subscriptions.data[0].plan.interval,
        interval_count:         customer.subscriptions.data[0].plan.interval_count,
        stripe_status:          customer.subscriptions.data[0].status,
      })
      subscription.save

      current_user.update_attributes(subscribed: true, subscribed_at: Time.now.utc)

      # TODO create OK/NG response
      present :subscription, subscription, with: Sample::Entities::Subscription, user: current_user
    end
    
    desc "create new Subscription (new: only subscription)"
    params do
      requires :plan_id, type: String, desc: "stripe plan_id (text)"
    end
    post do
      error!('already subscription', 400) if current_user.subscribed?

      customer = current_user.customer
      customer.plan = params[:plan_id]
      customer.save

      # update credit card
      #current_user.save_credit_card(customer.sources.first)

      subscription = current_user.create_subscription({
        stripe_subscription_id: customer.subscriptions.data[0].id,
        stripe_plan_id:         customer.subscriptions.data[0].plan.id,
        amount:                 customer.subscriptions.data[0].plan.amount,
        interval:               customer.subscriptions.data[0].plan.interval,
        interval_count:         customer.subscriptions.data[0].plan.interval_count,
        stripe_status:          customer.subscriptions.data[0].status,
      })
      subscription.save

      current_user.update_attributes(subscribed: true, subscribed_at: Time.now.utc)

      # TODO create OK/NG response
      present :subscription, subscription, with: Sample::Entities::Subscription, user: current_user
    end


    desc "update subscription (プラン変更)"
    params do
      requires :plan_id, type: String, desc: "stripe plan_id (text)"
    end
    put '/edit-plan' do
      error!('not subscription', 400) if !current_user.subscribed?

      subscription = Stripe::Subscription.retrieve(current_user.subscription.stripe_subscription_id)
      # 同じプランはNG
      error!('not same plan', 400) if subscription.plan.id == params[:plan_id]

      subscription.plan = params[:plan_id]
      subscription.save

      current_user.subscription.update_attributes(
        stripe_plan_id:         subscription.plan.id,
        amount:                 subscription.plan.amount,
        interval:               subscription.plan.interval,
        interval_count:         subscription.plan.interval_count,
        stripe_status:          subscription.status,
      )
      current_user.update_attributes(subscribed: true, subscribed_at: Time.now.utc)

      present :subscription, current_user.subscription, with: Sample::Entities::Subscription, user: current_user
    end

    desc "update card (カード変更)"
    params do
      requires :card, type: Hash do
        requires :number, type: String, desc: "card number"
        requires :exp_month, type: Integer, desc: "card exp_month"
        requires :exp_year, type: Integer, desc: "card exp_year"
        requires :cvc, type: String, desc: "card cvc"
        #optional :name, type: String, desc: "card holders full name", default:nil
      end
    end
    put '/edit-card' do
      error!('not subscription', 400) if !current_user.subscribed?

      customer    = current_user.customer
      customer.source = {
        object: 'card',
        number:    params[:card][:number],
        exp_month: params[:card][:exp_month],
        exp_year:  params[:card][:exp_year],
        cvc:       params[:card][:cvc]
      }
      customer.save
      # update credit card
      #current_user.save_credit_card(customer.sources.first)

      #present current_user.credit_card, with: Sample::Entities::CreditCard, user: current_user
    end


    desc "delete subscription"
    delete do
      error!('not subscription', 400) if !current_user.subscribed?

      # delete subscription
      subscription = Stripe::Subscription.retrieve(current_user.subscription.stripe_subscription_id)
      subscription.delete

      # ユーザの課金フラグを消す。stripe_customer_idは残す
      current_user.update_attributes(subscribed: false, subscribed_at: Time.now.utc)
      current_user.subscription.delete
    end


  end

end
