class UserTicket < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  attr_accessor :number_of_tickets

  attr_accessor :event_name
  attr_accessor :event_start_date
  attr_accessor :place_name
end
