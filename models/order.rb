class Order < ActiveRecord::Base
  has_many :foods
  has_many :parties
  belongs_to :party
  belongs_to :food
end