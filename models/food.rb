class Food < ActiveRecord::Base
   has_many :parties, {:through => :orders}
   has_many :orders


   #Cannot create a new food if it has the same name as 
   #one already in the database
   validates_uniqueness_of :name, {
    message: "Sorry, that food item already exists"
   } 

end