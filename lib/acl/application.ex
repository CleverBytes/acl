defmodule Acl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Acl.Repo,
      {DNSCluster, query: Application.get_env(:acl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Acl.PubSub},
      # Start a worker by calling: Acl.Worker.start_link(arg)
      # {Acl.Worker, arg},
      # Start to serve requests, typically the last entry
      AclWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AclWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
