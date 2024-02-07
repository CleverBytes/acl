defmodule Acl.ACL.ResourceService do
  alias Acl.ACL

  def create(resource_params) do
    ACL.create_resource(resource_params)
  end
end
