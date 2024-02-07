defmodule Acl.ACL.RoleService do
  alias Acl.ACL

  def create(role_params) do
    ACL.create_role(role_params)
  end
end
