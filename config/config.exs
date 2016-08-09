# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :hello_world,
  greeting: "Hello World!"

config :logger,
  backends: [
    :console
  ],
  level: :debug,
  utc_log: true

import_config "#{Mix.env}.exs"
