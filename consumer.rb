require 'dotenv/load'
require 'signalwire'
require 'net/http'

Signalwire::Logger.logger.level = ::Logger::DEBUG

class ::Consumer < Signalwire::Relay::Consumer
  contexts ['dialer']

  def on_task(task)
    logger.debug "Received #{task.message}"
    destination = task.message[:number]
    send_event("Calling #{destination}")

    # create call handle
    call = client.calling.new_call(from: ENV['FROM_NUMBER'], to: destination)
    # call
    dial_result = call.dial
    send_event("Dialing #{destination} successful?: #{dial_result.successful}")
    # perform AMD
    if dial_result.successful
      amd_result = call.detect_answering_machine(machine_words_threshold: 8, wait_for_beep: true)
      send_event("AMD for #{destination}: #{amd_result.result}")
      if amd_result.result == 'HUMAN'
        send_event("Sending #{destination} to agent")
        agent_dial = call.connect [[{ type: 'phone', params: { to_number: ENV['AGENT_NUMBER'], from_number: ENV['FROM_NUMBER'], timeout: 30 } }]]
        agent_dial.call.wait_for_ending
      else
        send_event("leaving #{destination} a message")
        call.play_tts text: 'Hello! We tried to reach to you but we could not find you. Please call back', language: 'en-US', gender: 'male'
      end
      send_event("call to #{destination} has ended")
      call.hangup
    else
      send_event("Dialing #{destination} failed")
    end
  end

  def send_event(body)
    uri = URI(ENV['API_URL'] + '/event')
    res = Net::HTTP.post_form(uri, event: body)
  end
end

::Consumer.new.run