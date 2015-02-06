class Party < ActiveRecord::Base
  has_many :foods, {:through => :orders}
  has_many :orders

  # def self.find_unpaid
  #   sql = Party
  # end
end