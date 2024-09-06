
class MessageAdapter
  def initialize(message)
    @message = message
  end

  def format
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class SMSAdapter < MessageAdapter
  def format
    "EASYPAY: Payment #{@message['status']} - Amount: #{@message['amount']} for #{@message['mobile_num']}"
  end
end

class PushNotificationAdapter < MessageAdapter
  def format
    "EASYPAY: Your payment of #{@message['amount']} was #{@message['status']}. Transaction ID: #{@message['payment_id']}"
  end
end

class EmailAdapter < MessageAdapter
  def format
    <<~EMAIL
      Subject: Payment #{@message['status'].capitalize} Notification

      Dear User,

      Your payment of #{@message['amount']} for mobile number #{@message['mobile_num']} was #{@message['status']}.

      Transaction Details:
      - Payment ID: #{@message['payment_id']}
      - Amount: #{@message['amount']}
      - Status: #{@message['status'].capitalize}
      - Date: #{@message['timestamp']}

      #{parse_plan(@message['plan'])}

      Thank you for using our service.

      Best regards,
      Easypay
    EMAIL
  end

  private

  def parse_plan(plan_json)
    plan = JSON.parse(plan_json)
    "Plan Details:\n- Cost: #{plan['amount']}\n- #{plan['details']}"
  rescue JSON::ParserError
    "Plan Details: Unable to parse plan information"
  end
end

class MessageFormatter
  def self.format(message)
    {
      sms: SMSAdapter.new(message).format,
      push: PushNotificationAdapter.new(message).format,
      email: EmailAdapter.new(message).format
    }
  end
end
