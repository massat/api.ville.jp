require 'sinatra'
require 'mongo'
require 'json'
require './app.rb'

configure :development do
  set :dsn, { :host => '127.0.0.1', :port => 27017, :db => 'ville'}
end

run Sinatra::Application
