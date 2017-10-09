class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subscription
  has_many :charges

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
    card.id
  end

  # stripe card_id
  # return string  e.g. "card_18oXxZJgEbT6Ft4J0QBohKDi"
#  def card_id
#    customer.sources.first.id
#  end

  # stripe subscription_id
  # return string  e.g. "sub_95lUmykFOcUUMH"
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

  # TODO Research STRIPE updated new API (create & update card)
  def card
    if self.stripe_card_id.present?
      customer.sources.retrieve(self.stripe_card_id)
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
    self.stripe_customer_id = customer.id
    self.save
    customer
  end

  # TODO Research STRIPE updated new API (create & update card)
  def create_card
      card = customer.sources.create(source: "tok_amex")
      self.stripe_card_id = card.id
      self.save
      card
  end
  
end
