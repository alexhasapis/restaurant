# establish connection with DB
ActiveRecord::Base.establish_connection(
  adapter: "postgresql", 
  database: "restaurant",
)

#require models
Dir["models/*.rb"].each do |file|
  require_relative file
end  

Dir["helpers/*.rb"].each do |file|
  require_relative file
end  

enable :sessions

#UTILITY ROUTES
#helpers WaitersHelper
get '/css/:name.css' do |name|
  content_type :css
  scss "../public/sass/#{name}".to_sym, :layout => false
end

get '/console' do
	Pry.start(binding)
end

get '/set/user/:id' do |id|
  session[:id] = id
  @waiter = waiter.find(id)
  redirect to('/welcome')
end

#index routes

get '/index' do
  erb :index
end

get '/foods' do 
  @foods = Food.all.order(:course, :style)
  erb :'/foods/index'
end

#only show parties that have not paid
get '/parties' do
  @parties = Party.all.select { |party| party.paid == false }
  erb :"parties/index"
end

get '/receipts' do
  @receipts = Receipt.all
  erb :"receipts/index"
end

#new routes
#create food
get "/foods/new" do
  erb :'foods/new'
end

post "/foods" do 
  new_food = Food.create(params[:food])

  if new_food.valid?
    redirect to ("/foods/#{new_food.id}")
  else
    @food = new_food
    @error_messages = new_food.errors.messages

    erb :'foods/new'
  end

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


#CREATE ORDERS

get "/parties/:id/orders/new" do |group|
  @foods = Food.all.order(:course, :style)
  @party = Party.find(group)
  erb :'orders/new'
end

post "/parties/:id/orders" do 
  params[:order].each do |order, quantity|
    if quantity[:quantity] > 0
      Order.create(party_id: params[:id], food_id: order.to_i, quantity: quantity[:quantity])  
    end
  end
  
  redirect to ("/parties/#{params[:id]}") 
end

#CLOSE ORDERS

post "/parties/:id/receipt" do
  #Pry.start(binding)
  party = Party.find(params[:id])
  new_receipt = Receipt.create(party_id: params[:id], total: params[:receipt][:total], tip: params[:receipt][:tip])
  party.update(paid: true)
  redirect to ("/receipts")
end


#EDIT ROUTES
#update
get '/foods/:id/edit' do |item|
  @food = Food.find(item)
  erb :'foods/edit'
end

patch '/foods/:id' do 
  edited_food = Food.find(params[:id])
  edited_food.update(params[:food])
  edited_food.save
  
  redirect to ("/foods/#{edited_food.id}")
end

get '/parties/:id/edit' do |group|
  @party = Party.find(group)
  erb :'/parties/edit'
end

get '/parties/:id/orders/edit' do |group|
  @foods = Food.all.order(:course, :style)
  @party = Party.find(group)
  #Pry.start(binding)
  erb :'orders/edit'
end

patch "/parties/:id/orders" do 
  params[:order].each do |order, quantity|
    if Order.where("food_id = #{order.to_i} and party_id = #{params[:id]}" ) != []    
      edit_order = Order.where( "food_id = #{order.to_i} and party_id = #{params[:id]}" )
      
      edit_order.update_all(quantity: quantity[:quantity])
      if edit_order.first.quantity == 0
        edit_order.destroy_all
      end
    elsif quantity[:quantity].to_i > 0
    Order.create(party_id: params[:id], food_id: order.to_i, quantity: quantity[:quantity])
    end
  end
  redirect to ("/parties/#{params[:id]}") 
end


patch '/parties/:id' do 
  edited_party = Party.find(params[:id])
  edited_party.update(params[:party])
  edited_party.save
  
  redirect to ("/parties/#{edited_party.id}")
end

#SHOW ROUTES

#Show Food with parties that have ordered
get '/foods/:id' do |item|
  @food = Food.find(item)
    erb :"foods/show"
end

get '/parties/:id' do |group|
  @party = Party.find(group)
    erb :"parties/show"
end

get "/parties/:id/receipt" do |group|
  @party = Party.find(group)
  @total = 0
  erb :'receipts/show'
end

#destroy
delete '/foods/:id' do 
  deleted_food = Food.find(params[:id])
  deleted_food.destroy
  
  redirect to ('/foods')
end

delete '/parties/:id' do
  deleted_party = Party.find(params[:id])
  party_orders = deleted_party.orders
  deleted_party.destroy
  
  party_orders.each do |order|
    order.destroy
  end

  redirect to ('/parties')
end

#wildcard route for invalid
get '*' do
  if session[:id]
    redirect to('/index')
  else
    "Please go to /set/user/id to log in."
  end
end


