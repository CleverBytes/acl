defmodule Acl.ACLTest do
  use Acl.DataCase

  alias Acl.ACL

  describe "acl_roles" do
    alias Acl.ACL.AclRole

    import Acl.ACLFixtures

    @invalid_attrs %{parent: nil, role: nil}

    test "list_acl_roles/0 returns all acl_roles" do
      acl_role = acl_role_fixture()
      assert ACL.list_acl_roles() == [acl_role]
    end

    test "get_acl_role!/1 returns the acl_role with given id" do
      acl_role = acl_role_fixture()
      assert ACL.get_acl_role!(acl_role.id) == acl_role
    end

    test "create_acl_role/1 with valid data creates a acl_role" do
      valid_attrs = %{parent: "some parent", role: "some role"}

      assert {:ok, %AclRole{} = acl_role} = ACL.create_acl_role(valid_attrs)
      assert acl_role.parent == "some parent"
      assert acl_role.role == "some role"
    end

    test "create_acl_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ACL.create_acl_role(@invalid_attrs)
    end

    test "update_acl_role/2 with valid data updates the acl_role" do
      acl_role = acl_role_fixture()
      update_attrs = %{parent: "some updated parent", role: "some updated role"}

      assert {:ok, %AclRole{} = acl_role} = ACL.update_acl_role(acl_role, update_attrs)
      assert acl_role.parent == "some updated parent"
      assert acl_role.role == "some updated role"
    end

    test "update_acl_role/2 with invalid data returns error changeset" do
      acl_role = acl_role_fixture()
      assert {:error, %Ecto.Changeset{}} = ACL.update_acl_role(acl_role, @invalid_attrs)
      assert acl_role == ACL.get_acl_role!(acl_role.id)
    end

    test "delete_acl_role/1 deletes the acl_role" do
      acl_role = acl_role_fixture()
      assert {:ok, %AclRole{}} = ACL.delete_acl_role(acl_role)
      assert_raise Ecto.NoResultsError, fn -> ACL.get_acl_role!(acl_role.id) end
    end

    test "change_acl_role/1 returns a acl_role changeset" do
      acl_role = acl_role_fixture()
      assert %Ecto.Changeset{} = ACL.change_acl_role(acl_role)
    end
  end

  describe "acl_resources" do
    alias Acl.ACL.AclResource

    import Acl.ACLFixtures

    @invalid_attrs %{parent: nil, resource: nil}

    test "list_acl_resources/0 returns all acl_resources" do
      acl_resource = acl_resource_fixture()
      assert ACL.list_acl_resources() == [acl_resource]
    end

    test "get_acl_resource!/1 returns the acl_resource with given id" do
      acl_resource = acl_resource_fixture()
      assert ACL.get_acl_resource!(acl_resource.id) == acl_resource
    end

    test "create_acl_resource/1 with valid data creates a acl_resource" do
      valid_attrs = %{parent: "some parent", resource: "some resource"}

      assert {:ok, %AclResource{} = acl_resource} = ACL.create_acl_resource(valid_attrs)
      assert acl_resource.parent == "some parent"
      assert acl_resource.resource == "some resource"
    end

    test "create_acl_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ACL.create_acl_resource(@invalid_attrs)
    end

    test "update_acl_resource/2 with valid data updates the acl_resource" do
      acl_resource = acl_resource_fixture()
      update_attrs = %{parent: "some updated parent", resource: "some updated resource"}

      assert {:ok, %AclResource{} = acl_resource} =
               ACL.update_acl_resource(acl_resource, update_attrs)

      assert acl_resource.parent == "some updated parent"
      assert acl_resource.resource == "some updated resource"
    end

    test "update_acl_resource/2 with invalid data returns error changeset" do
      acl_resource = acl_resource_fixture()
      assert {:error, %Ecto.Changeset{}} = ACL.update_acl_resource(acl_resource, @invalid_attrs)
      assert acl_resource == ACL.get_acl_resource!(acl_resource.id)
    end

    test "delete_acl_resource/1 deletes the acl_resource" do
      acl_resource = acl_resource_fixture()
      assert {:ok, %AclResource{}} = ACL.delete_acl_resource(acl_resource)
      assert_raise Ecto.NoResultsError, fn -> ACL.get_acl_resource!(acl_resource.id) end
    end

    test "change_acl_resource/1 returns a acl_resource changeset" do
      acl_resource = acl_resource_fixture()
      assert %Ecto.Changeset{} = ACL.change_acl_resource(acl_resource)
    end
  end

  describe "acl_rules" do
    alias Acl.ACL.AclRule

    import Acl.ACLFixtures

    @invalid_attrs %{action: nil}

    test "list_acl_rules/0 returns all acl_rules" do
      acl_rule = acl_rule_fixture()
      assert ACL.list_acl_rules() == [acl_rule]
    end

    test "get_acl_rule!/1 returns the acl_rule with given id" do
      acl_rule = acl_rule_fixture()
      assert ACL.get_acl_rule!(acl_rule.id) == acl_rule
    end

    test "create_acl_rule/1 with valid data creates a acl_rule" do
      valid_attrs = %{action: "some action"}

      assert {:ok, %AclRule{} = acl_rule} = ACL.create_acl_rule(valid_attrs)
      assert acl_rule.action == "some action"
    end

    test "create_acl_rule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ACL.create_acl_rule(@invalid_attrs)
    end

    test "update_acl_rule/2 with valid data updates the acl_rule" do
      acl_rule = acl_rule_fixture()
      update_attrs = %{action: "some updated action"}

      assert {:ok, %AclRule{} = acl_rule} = ACL.update_acl_rule(acl_rule, update_attrs)
      assert acl_rule.action == "some updated action"
    end

    test "update_acl_rule/2 with invalid data returns error changeset" do
      acl_rule = acl_rule_fixture()
      assert {:error, %Ecto.Changeset{}} = ACL.update_acl_rule(acl_rule, @invalid_attrs)
      assert acl_rule == ACL.get_acl_rule!(acl_rule.id)
    end

    test "delete_acl_rule/1 deletes the acl_rule" do
      acl_rule = acl_rule_fixture()
      assert {:ok, %AclRule{}} = ACL.delete_acl_rule(acl_rule)
      assert_raise Ecto.NoResultsError, fn -> ACL.get_acl_rule!(acl_rule.id) end
    end

    test "change_acl_rule/1 returns a acl_rule changeset" do
      acl_rule = acl_rule_fixture()
      assert %Ecto.Changeset{} = ACL.change_acl_rule(acl_rule)
    end
  end
end
