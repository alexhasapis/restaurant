require 'bundler'
Bundler.require

set :scss, {:style => :compressed, :debug_info => false}

require './app'
run Sinatra::Application