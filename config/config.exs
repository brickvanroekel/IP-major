# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :project,
  ecto_repos: [Project.Repo]

config :project_web,
  ecto_repos: [Project.Repo],
  generators: [context_app: :project]

# Configures the endpoint
config :project_web, ProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kCLy/Ixt3ZcS64XyxhqMY4AISLbOGS1DTy4RCiXLn1FNi65KqUHXWRcHQeioA2ou",
  render_errors: [view: ProjectWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Project.PubSub,
  live_view: [signing_salt: "H5YLgJZD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :project_web, ProjectWeb.Guardian,
  issuer: "project_web",
  secret_key: "ymyW3XKaSaaF6dz8Y/ZvIpX/sz20lLrmO2nVcsKVco1D1y5+7/wRkLxc8I8R6pOK"

config :i18n_translations, I18nTranslations.Gettext,
locales: ~w(en nl),
default_locale: "en"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
