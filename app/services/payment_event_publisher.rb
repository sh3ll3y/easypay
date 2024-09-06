class PaymentEventPublisher
  TOPIC = 'payment_events'.freeze

  def self.publish(payment_id, amount, status, user_id, biller_id, mobile_num, plan, metadata = {})
    event = {
      payment_id: payment_id.to_s,
      amount: amount.to_s,
      status: status.to_s,
      user_id: user_id.to_s,
      biller_id: biller_id.to_s,
      mobile_num: mobile_num.to_s,
      plan: plan,
      metadata: metadata,
      timestamp: Time.now.iso8601
    }.to_json

    KAFKA_PRODUCER.deliver_message(event, topic: TOPIC)
  end
end

class NotificationEventPublisher
  TOPIC = 'notification_events'.freeze

  def self.publish(payment_id, amount, status, user_id, biller_id, mobile_num, plan, metadata = {})

    event = {
      payment_id: payment_id.to_s,
      amount: amount.to_s,
      status: status.to_s,
      user_id: user_id.to_s,
      biller_id: biller_id.to_s,
      mobile_num: mobile_num.to_s,
      plan: plan,
      metadata: metadata,
      timestamp: Time.now.iso8601
    }.to_json

    KAFKA_PRODUCER.deliver_message(event, topic: TOPIC)
  end
end
