require 'bundler'
Bundler.require

require './app'

map('/foods') { run FoodsController }
#map('/parties') { run PartiesController }

run Restaurant
