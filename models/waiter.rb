class Waiter < ActiveRecord::Base
	has_many :parties, {:through => :receipts}
	has_many :receipts
end