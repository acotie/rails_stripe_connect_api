module Sample::Entities

  class Base < Grape::Entity
    expose :id, documentation: {type: Integer, desc: "Object ID"}
    expose :created_at
    expose :updated_at
  end

  class Meta < Grape::Entity
    expose :page_total_count
    expose :page
    expose :records_per_page
    expose :records_yielded_count
  end

  class User < Base
    expose :subscribed
    expose :subscribed_at
    expose :stripe_customer_id
    expose :stripe_card_id
  end

  class Subscription < Base
    expose :amount
    expose :stripe_subscription_id
    expose :stripe_plan_id
    expose :interval
    expose :interval_count
    expose :stripe_status
    expose :user, using: Sample::Entities::User
  end

  class Charge < Base
    expose :amount
    expose :currency
    expose :stripe_charge_id
    expose :user, using: Sample::Entities::User
  end

end
