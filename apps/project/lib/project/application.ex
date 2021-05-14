defmodule Project.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Project.Repo,

      Project.Workers.CartAgent,
      # Start the PubSub system
      {Phoenix.PubSub, name: Project.PubSub}

      # Start a worker by calling: Project.Worker.start_link(arg)
      # {Project.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Project.Supervisor)
  end
end
