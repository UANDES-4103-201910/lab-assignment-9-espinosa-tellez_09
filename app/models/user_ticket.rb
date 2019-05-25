class UserTicket < ApplicationRecord
  belongs_to :user
  belongs_to :ticket

  validates :n_bought, :numericality => { :greater_than => 0 }

end
