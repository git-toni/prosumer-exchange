# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :power_web,
  namespace: PowerWeb

# Configures the endpoint
config :power_web, PowerWeb.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AfOHwDVgvWgyvm9cLQ/G7ZWK/XDT2b68/woYuIhhtuoKknEj4wn0yK4jXMRyY6ul",
  render_errors: [view: PowerWeb.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PowerWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
