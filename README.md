# SignalWire Relay Autodialer Demo

This application implements an example of an automatic dialer application that showcases how easy it is to add Relay to your stack.

To run it, you will first need a SignalWire account. If you do not have one, you can sign up [here](https://signalwire.com).

After signing up, grab an API key from your dashboard and note your Space name.

Copy `env.example` to `.env` and fill in the environment variables.

You will need an `AGENT_NUMBER` to call, and a `FROM_NUMBER` to use as the caller ID. That caller ID needs to be a number you own or have verified on your SignalWire Space, which also needs to be out of [trial mode](https://signalwire.com/resources/getting-started/trial-mode).

You can optionally pre-fill a list of numbers to call in the `PHONE_NUMBERS` environment variable.

## Running locally

The application is written in Ruby and is composed of two parts, a Sinatra web application and a Relay Consumer.

There is a sample `docker-compose` setup provided, so after setting up your environment, just run `docker-compose up` and go to [http://localhost:9292](http://localhost:9292).

## Documentation links

[Relay Documentation](https://docs.signalwire.com/topics/relay/#relay-documentation)

[Relay Docker Images](https://github.com/signalwire/signalwire-relay-docker)

[SignalWire 101](https://signalwire.com/resources/getting-started/signalwire-101)

Copyright 2021, [SignalWire Inc.](https://signalwire.com)