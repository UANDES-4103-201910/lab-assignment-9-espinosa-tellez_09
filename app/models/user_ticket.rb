class UserTicket < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  attr_accessor :number_of_tickets

end
