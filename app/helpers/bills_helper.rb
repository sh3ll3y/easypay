module BillsHelper
  def bill_status_color(status)
    case status
    when 'pending'
      'badge-warning'
    when 'paid'
      'badge-success'
    when 'expired'
      'badge-danger'
    else
      'badge-secondary'
    end
  end
end
