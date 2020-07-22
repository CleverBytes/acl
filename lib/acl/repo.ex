defmodule Acl.Repo do
  @moduledoc false

#  use Ecto.Repo,
#      otp_app: :acl,
#      adapter: Ecto.Adapters.Postgres
  def repo do
    :acl
    |> Application.fetch_env!(Acl.Repo)
    |> Keyword.fetch!(:repo)
  end
  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
