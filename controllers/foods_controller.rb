class FoodsController < ApplicationController


#CREATE

  get "/new" do
    erb :'foods/new'
  end


  post "/" do
    new_food = Food.create(params[:food])

    if new_food.valid?
      redirect to ("/foods/#{new_food.id}")
    else
      @food = new_food
      @error_messages = new_food.errors.messages

      erb :'foods/new'
    end

  end


#EDIT


  get '/:id/edit' do |item|
    @food = Food.find(item)
    erb :'foods/edit'
  end

  patch '/:id' do
    edited_food = Food.find(params[:id])
    edited_food.update(params[:food])
    edited_food.save

    redirect to ("/foods/#{edited_food.id}")
  end


#SHOW

  get '/' do
    @foods = Food.all.order(:course, :style)
    erb :'/foods/index'
  end


  get '/:id' do |item|
    @food = Food.find(item)
      erb :"foods/show"
  end



#DELETE


  delete '/:id' do
    deleted_food = Food.find(params[:id])
    food_orders = deleted_food.orders
    deleted_food.destroy

    food_orders.each do |order|
      order.destroy
    end
    redirect to ('/foods')
  end

end
