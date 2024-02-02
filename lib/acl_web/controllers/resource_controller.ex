defmodule AclWeb.ResourceController do
  use AclWeb, :controller

  alias Acl.ACL
  alias Acl.ACL.Resource

  action_fallback AclWeb.FallbackController

  def index(conn, _params) do
    resources = ACL.list_resources()
    render(conn, :index, resources: resources)
  end

  def create(resource_params) do
    ACL.create_resource(resource_params)
  end

  def show(conn, %{"id" => id}) do
    resource = ACL.get_resource!(id)
    render(conn, :show, resource: resource)
  end

  def update(conn, %{"id" => id, "resource" => resource_params}) do
    resource = ACL.get_resource!(id)

    with {:ok, %Resource{} = resource} <- ACL.update_resource(resource, resource_params) do
      render(conn, :show, resource: resource)
    end
  end

  def delete(conn, %{"id" => id}) do
    resource = ACL.get_resource!(id)

    with {:ok, %Resource{}} <- ACL.delete_resource(resource) do
      send_resp(conn, :no_content, "")
    end
  end
end
