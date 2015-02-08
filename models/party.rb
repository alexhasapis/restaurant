class Party < ActiveRecord::Base
  has_many :foods, {:through => :orders}
  has_many :orders
  has_one :waiter, {:through => :receipts}

  # def self.find_unpaid
  #   sql = Party
  # end
end