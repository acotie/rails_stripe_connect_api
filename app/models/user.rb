class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subscription

  #############################################
  ##### Start Connection Stripe Objects #######
  #############################################
  # stripe customer_id
  # return string  e.g. "cus_96gOUYURouuWjz"
  def customer_id
    customer.id
  end

  # stripe card_id
  # return string  e.g. "card_18oXxZJgEbT6Ft4J0QBohKDi"
  def card_id
    customer.sources.first.id
  end

  # stripe subscription_id
  # return string  e.g. "sub_96lUmykFOcUUMH"
  def subscription_id
    customer.subscriptions.first.id
  end


  # Stripe::Card object
  # see https://stripe.com/docs/api#card_object
  def card_data
    customer.sources.first
  end

  # Stripe::Subscription object
  # see https://stripe.com/docs/api#subscription_object
  def subscription_data
    customer.subscriptions.first
  end


  # for API
  # Stripe::Customer object
  # see https://stripe.com/docs/api#customer_object
  # TODO: plan, cardは後からupdate
  def customer
    if self.stripe_customer_id.present?
      Stripe::Customer.retrieve(self.stripe_customer_id)
    else
      create_customer
    end
  end

  # TODO
  def card
    if customer.sources.all(:object => "card").present?
      customer.sources.all(:object => "card")
    else
      create_card
    end
  end

  #############################################
  ###### End Connection Stripe Objects ########
  #############################################
  

  private

  def create_customer
    customer = Stripe::Customer.create(
      email:       self.email,
      description: "Customer for #{self.email}",
    )
    create_card
    self.stripe_customer_id = customer.id
    self.save
    customer
  end

  # TODO move credit_card DB
  def create_card
    if customer.sources.all(:object => "card").present?
      customer.sources.all(:object => "card")
    else
      customer.surces.create(source: "tok_amex")
      customer.save
    end
  end
  
end
