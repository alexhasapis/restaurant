# establish connection with DB
ActiveRecord::Base.establish_connection(
  adapter: "postgresql", 
  database: "restaurant",
)

#require models
Dir["models/*.rb"].each do |file|
  require_relative file
end  

#UTILITY ROUTES

get '/console' do
	Pry.start(binding)
end

#index routes

get '/' do
  erb :index
end

get '/foods' do 
  @foods = Food.all
  erb :'/foods/index'
end

#only show parties that have not paid
get '/parties' do
  #@parties = Party.find_by_paid(false)
  @parties = Party.all
  erb :"parties/index"
end

#new routes
#create food
get "/foods/new" do
  erb :'foods/new'
end

post "/foods" do 
  @new_food = Food.create(params[:food])
  redirect to ("/foods/#{@new_food.id}")
end

#create parties
get "/parties/new" do
  erb :'parties/new'
end

post "/parties" do 
  #Pry.start(binding)
  @new_party = Party.create(params[:party])
  redirect to ("/parties/#{@new_party.id}")
end

#edit routes
#update
get '/foods/:id/edit' do |food_id|
  @food = Food.find(food_id)
  erb :'foods/edit'
end

patch '/foods/:id' do 
  edited_food = Food.find(params[:id])
  edited_food.update(params[:food])
  edited_food.save
  redirect to ("/foods/#{edited_food.id}")
end

get '/parties/:id/edit' do |party_id|
  @party = Party.find(party_id)
  erb :'/parties/edit'
end

patch '/parties/:id' do 
  edited_party = Party.find(params[:id])
  edited_party.update(params[:party])
  edited_party.save
  redirect to ("/parties/#{edited_party.id}")
end

#show routes

#Show Food with parties that have ordered
get '/foods/:id' do |food_id|
  @food = Food.find(food_id)
    erb :"foods/show"
end

get '/parties/:id' do |party_id|
  @party = Party.find(party_id)
    erb :"parties/show"
end

#destroy
delete '/foods/:id' do 
  deleted_food = Food.find(params[:id])
  deleted_food.destroy
  redirect to ('/foods')
end

delete '/parties/:id' do
  deleted_party = Party.find(params[:id])
  deleted_orders = deleted_party.orders
  deleted_party.destroy
  deleted_orders.destroy

  redirect to ('/parties')
end

#wildcard route for invalid
get '/*' do
  erb :index
end



#receipt page group by food, need sum