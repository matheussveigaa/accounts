defmodule AccountsApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AccountsApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: AccountsApi.PubSub},
      # Start the Endpoint (http/https)
      AccountsApiWeb.Endpoint,
      {Task.Supervisor, name: AccountsApi.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AccountsApi.Supervisor]

    AccountsApi.Infrastructure.Persistence.MnesiaAdapter.start()

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AccountsApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
