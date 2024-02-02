defmodule AclWeb.RoleController do
  use AclWeb, :controller

  alias Acl.ACL
  alias Acl.ACL.Role

  action_fallback AclWeb.FallbackController

  def index(conn, _params) do
    roles = ACL.list_roles()
    render(conn, :index, roles: roles)
  end

  def create(role_params) do
    ACL.create_role(role_params)
  end

  def show(conn, %{"id" => id}) do
    role = ACL.get_role!(id)
    render(conn, :show, role: role)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = ACL.get_role!(id)

    with {:ok, %Role{} = role} <- ACL.update_role(role, role_params) do
      render(conn, :show, role: role)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = ACL.get_role!(id)

    with {:ok, %Role{}} <- ACL.delete_role(role) do
      send_resp(conn, :no_content, "")
    end
  end
end
