module AppointmentsHelper
  def appointment_status_color(status)
    case status
    when 'confirmed' then 'bg-green-100 text-green-800'
    when 'completed' then 'bg-purple-100 text-purple-800'
    when 'cancelled' then 'bg-red-100 text-red-800'
    else 'bg-yellow-100 text-yellow-800'
    end
  end
end
