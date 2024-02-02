defmodule AclWeb.ResourceJSON do
  alias Acl.ACL.Resource

  @doc """
  Renders a list of resources.
  """
  def index(%{resources: resources}) do
    %{data: for(resource <- resources, do: data(resource))}
  end

  @doc """
  Renders a single resource.
  """
  def show(%{resource: resource}) do
    %{data: data(resource)}
  end

  defp data(%Resource{} = resource) do
    %{id: resource.id, parent: resource.parent}
  end
end
