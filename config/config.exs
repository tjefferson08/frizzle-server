# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :frizzle,
  ecto_repos: [Frizzle.Repo]

# Configures the endpoint
config :frizzle, Frizzle.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "479WNM/UqKHtZ6M4ri/l2Q9cObumznJM78f5FXDXSgj9VVwN0nrD4TPLAZ1SkRV/",
  render_errors: [view: Frizzle.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Frizzle.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
