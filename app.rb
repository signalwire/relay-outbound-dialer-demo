require 'dotenv/load'
require 'sinatra'
require 'signalwire'
require 'sucker_punch'

class TaskJob
  include SuckerPunch::Job

  def perform(num)
    task = Signalwire::Relay::Task.new(
      project: ENV['SIGNALWIRE_PROJECT_KEY'],
      token: ENV['SIGNALWIRE_TOKEN'],
      host: ENV['SIGNALWIRE_TASK_HOST']
    )
    
    task.deliver(context: 'dialer', message: { number: num })
  end
end

get '/' do
  erb :index
end

post '/event' do
  puts params[:event]
  settings.faye_client.publish( '/updates', event: params[:event] )
end

post '/start' do
  numbers = params['numbers'].split("\n").map(&:strip);
  numbers.each do |num|
    unless num.empty?
      puts "calling #{num}"
      TaskJob.perform_async(num)
    end
  end
  'ok'
end