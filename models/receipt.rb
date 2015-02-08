class Receipt < ActiveRecord::Base
   has_many :parties
   has_many :waiters
   belongs_to :party
   belongs_to :waiter
end