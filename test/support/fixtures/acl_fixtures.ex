defmodule Acl.ACLFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Acl.ACL` context.
  """

  @doc """
  Generate a unique acl_role role.
  """
  def unique_acl_role_role, do: "some role#{System.unique_integer([:positive])}"

  @doc """
  Generate a acl_role.
  """
  def acl_role_fixture(attrs \\ %{}) do
    {:ok, acl_role} =
      attrs
      |> Enum.into(%{
        parent: "some parent",
        role: unique_acl_role_role()
      })
      |> Acl.ACL.create_acl_role()

    acl_role
  end

  @doc """
  Generate a unique acl_resource resource.
  """
  def unique_acl_resource_resource, do: "some resource#{System.unique_integer([:positive])}"

  @doc """
  Generate a acl_resource.
  """
  def acl_resource_fixture(attrs \\ %{}) do
    {:ok, acl_resource} =
      attrs
      |> Enum.into(%{
        parent: "some parent",
        resource: unique_acl_resource_resource()
      })
      |> Acl.ACL.create_acl_resource()

    acl_resource
  end

  @doc """
  Generate a acl_rule.
  """
  def acl_rule_fixture(attrs \\ %{}) do
    {:ok, acl_rule} =
      attrs
      |> Enum.into(%{
        action: "some action"
      })
      |> Acl.ACL.create_acl_rule()

    acl_rule
  end
end
