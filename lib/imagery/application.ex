defmodule Imagery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ImageryWeb.Telemetry,
      Imagery.Repo,
      {DNSCluster, query: Application.get_env(:imagery, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Imagery.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Imagery.Finch},
      # Start a worker by calling: Imagery.Worker.start_link(arg)
      # {Imagery.Worker, arg},
      # Start to serve requests, typically the last entry
      ImageryWeb.Endpoint,
      {Task.Supervisor, name: Imagery.TaskSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Imagery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ImageryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
