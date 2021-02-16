require 'sinatra'
require 'faye'

require './app'

set :port, 9292

Faye::WebSocket.load_adapter('thin')
# use Faye::RackAdapter, :mount => '/faye', :timeout => 25

bayeux = Faye::RackAdapter.new(:mount => '/', :timeout => 25)
set :faye_client, bayeux.get_client

map '/faye' do
  run bayeux
end

map "/" do
  run Sinatra::Application
end