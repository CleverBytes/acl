defmodule Acl.ACL do
  @moduledoc """
  The ACL context.
  """

  import Ecto.Query, warn: false
  @repo Acl.Repo.repo()

  alias Acl.ACL.Role

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    @repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Acl role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: @repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    @repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  alias Acl.ACL.Resource

  @doc """
  Returns the list of resources.

  ## Examples

      iex> list_resources()
      [%Resource{}, ...]

  """
  def list_resources do
    @repo.all(Resource)
  end

  @doc """
  Gets a single resource.

  Raises `Ecto.NoResultsError` if the Acl resource does not exist.

  ## Examples

      iex> get_resource!(123)
      %Resource{}

      iex> get_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resource!(id), do: @repo.get!(Resource, id)
  def get_resource(resource), do: @repo.get_by(Resource, resource: resource)

  @doc """
  Creates a resource.

  ## Examples

      iex> create_resource(%{field: value})
      {:ok, %Resource{}}

      iex> create_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource(attrs \\ %{}) do
    %Resource{}
    |> Resource.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a resource.

  ## Examples

      iex> update_resource(resource, %{field: new_value})
      {:ok, %Resource{}}

      iex> update_resource(resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a resource.

  ## Examples

      iex> delete_resource(resource)
      {:ok, %Resource{}}

      iex> delete_resource(resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    @repo.delete(resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource changes.

  ## Examples

      iex> change_resource(resource)
      %Ecto.Changeset{data: %Resource{}}

  """
  def change_resource(%Resource{} = resource, attrs \\ %{}) do
    Resource.changeset(resource, attrs)
  end

  alias Acl.ACL.Rule

  @doc """
  Returns the list of rules.

  ## Examples

      iex> list_rules()
      [%Rule{}, ...]

  """
  def list_rules do
    @repo.all(Rule)
  end

  @doc """
  Gets a single rule.

  Raises `Ecto.NoResultsError` if the Acl rule does not exist.

  ## Examples

      iex> get_rule!(123)
      %Rule{}

      iex> get_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rule!(id), do: @repo.get!(Rule, id)

  def get_rule_by(%{"role" => role, "resource" => resource, "action" => nil, "permission" => nil}) do
    @repo.one(
      from r in Rule,
        where:
          r.role == ^role and r.resource_id == ^resource and is_nil(r.action) and
            is_nil(r.permission),
        preload: [:resource]
    )
    |> case do
      nil -> {:error, :rule_not_found}
      rule -> rule
    end
  end

  def get_rule_by(%{
        "role" => role,
        "resource" => resource,
        "action" => action,
        "permission" => nil
      }) do
    @repo.one(
      from r in Rule,
        where:
          r.role == ^role and r.resource_id == ^resource and r.action == ^action and
            is_nil(r.permission),
        preload: [:resource]
    )
    |> case do
      nil -> {:error, :rule_not_found}
      rule -> rule
    end
  end

  def get_rule_by(%{
        "role" => role,
        "resource" => resource,
        "permission" => permission,
        "action" => action
      }) do
    if is_nil(action) do
      @repo.one(
        from r in Rule,
          where:
            r.role == ^role and r.resource_id == ^resource and is_nil(r.action) and
              r.permission == ^permission,
          preload: [:resource]
      )
      |> case do
        nil -> {:error, :rule_not_found}
        rule -> rule
      end
    else
      Rule
      |> @repo.get_by(role: role, resource_id: resource, permission: permission, action: action)
      |> case do
        nil -> {:error, :rule_not_found}
        rule -> rule
      end
    end
  end

  def get_rule_by(%{"role" => role, "resource" => resource, "action" => action}) do
    Rule
    |> @repo.all(role: role, resource_id: resource, action: action)
    |> @repo.preload(:resource)
    |> case do
      nil -> {:error, :rule_not_found}
      [] -> {:error, :rule_not_found}
      rule -> rule
    end
  end

  def get_rule_by(%{"role" => role, "resource" => resource}) do
    case @repo.all(Rule, role: role, resource_id: resource) do
      nil -> {:error, :rule_not_found}
      rule -> rule
    end
  end

  def get_rule_by(role) do
    case Role
         |> @repo.get(role)
         |> @repo.preload([{:rules, :resource}]) do
      nil -> {:error, :rule_not_found}
      records -> records
    end
  end

  @doc """
  Creates a rule.

  ## Examples

      iex> create_rule(%{field: value})
      {:ok, %Rule{}}

      iex> create_rule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rule(attrs \\ %{}) do
    %Rule{}
    |> Rule.changeset(attrs, attrs["resource"])
    |> @repo.insert()
  end

  @doc """
  Updates a rule.

  ## Examples

      iex> update_rule(rule, %{field: new_value})
      {:ok, %Rule{}}

      iex> update_rule(rule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rule(%Rule{} = rule, attrs) do
    cs = Rule.u_changeset(rule, attrs)

    if cs.changes != %{} do
      @repo.update(cs)
    end
  end

  @doc """
  Deletes a rule.

  ## Examples

      iex> delete_rule(rule)
      {:ok, %Rule{}}

      iex> delete_rule(rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rule(%Rule{} = rule) do
    @repo.delete(rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rule changes.

  ## Examples

      iex> change_rule(rule)
      %Ecto.Changeset{data: %Rule{}}

  """
  def change_rule(%Rule{} = rule, attrs \\ %{}) do
    Rule.changeset(rule, attrs, %{})
  end
end
