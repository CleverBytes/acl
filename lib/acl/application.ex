defmodule Acl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
#      Acl.Repo,
      {DNSCluster, query: Application.get_env(:acl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Acl.PubSub}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
