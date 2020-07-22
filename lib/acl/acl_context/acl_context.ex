defmodule Acl.Acl_context do
  @moduledoc false
 """
  The Acl_context context.
  """

  import Ecto.Query, warn: false
  alias Acl.Repo

  alias Acl.Acl_context.Role

  @doc """
  Returns the list of acl_roles.

  ## Examples

      iex> list_acl_roles()
      [%Role{}, ...]

  """
  def list_acl_roles do
    Repo.repo().all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.repo().get!(Role, id)

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
    |> Repo.repo().insert()
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
    |> Repo.repo().update()
  end

  @doc """
  Deletes a Role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.repo().delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{source: %Role{}}

  """
  def change_role(%Role{} = role) do
    Role.changeset(role, %{})
  end

  alias Acl.Acl_context.Res

  @doc """
  Returns the list of acl_res.

  ## Examples

      iex> list_acl_res()
      [%Res{}, ...]

  """
  def list_acl_res do
    Repo.repo().all(Res)
  end

  @doc """
  Gets a single res.

  Raises `Ecto.NoResultsError` if the Res does not exist.

  ## Examples

      iex> get_res!(123)
      %Res{}

      iex> get_res!(456)
      ** (Ecto.NoResultsError)

  """
  def get_res!(id), do: Repo.repo().get!(Res, id)
  def get_res(res), do: Repo.repo().get_by(Res, [res: res])

  @doc """
  Creates a res.

  ## Examples

      iex> create_res(%{field: value})
      {:ok, %Res{}}

      iex> create_res(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_res(attrs \\ %{}) do
    %Res{}
    |> Res.changeset(attrs)
    |> Repo.repo().insert()
  end

  @doc """
  Updates a res.

  ## Examples

      iex> update_res(res, %{field: new_value})
      {:ok, %Res{}}

      iex> update_res(res, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_res(%Res{} = res, attrs) do
    res
    |> Res.changeset(attrs)
    |> Repo.repo().update()
  end

  @doc """
  Deletes a Res.

  ## Examples

      iex> delete_res(res)
      {:ok, %Res{}}

      iex> delete_res(res)
      {:error, %Ecto.Changeset{}}

  """
  def delete_res(%Res{} = res) do
    Repo.repo().delete(res)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking res changes.

  ## Examples

      iex> change_res(res)
      %Ecto. {source: %Res{}}

  """
  def change_res(%Res{} = res) do
    Res.changeset(res, %{})
  end

  alias Acl.Acl_context.Rule

  @doc """
  Returns the list of acl_rules.

  ## Examples

      iex> list_acl_rules()
      [%Rule{}, ...]

  """
  def list_acl_rules do
    Repo.repo().all(Rule)
  end

  @doc """
  Gets a single rule.

  Raises `Ecto.NoResultsError` if the Rule does not exist.

  ## Examples

      iex> get_rule!(123)
      %Rule{}

      iex> get_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rule!(id), do: Repo.repo().get!(Rule, id)





  def get_rule_by(%{"role" => role, "res" => res, "action" => nil, "permission" => nil})do
    case Repo.repo().one from r in Rule,
                  where: r.role == ^role and r.res_id == ^res and is_nil(r.action) and is_nil(r.permission),
                  preload: [
                    :res
                  ]
      do
      nil -> {:error, :rule_not_found}
      rule -> rule
    end
  end
  def get_rule_by(%{"role" => role, "res" => res, "action" => action, "permission" => nil})do

    case Repo.repo().one from r in Rule,
                  where: r.role == ^role and r.res_id == ^res and r.action == ^action and is_nil(r.permission),
                  preload: [:res]
      do
      nil -> {:error, :rule_not_found}
      rule -> rule
    end
  end
  def get_rule_by(%{"role" => role, "res" => res, "permission" => permission, "action" => action})do
    if  is_nil(action)
      do
      case Repo.repo().one from r in Rule,
                    where: r.role == ^role and r.res_id == ^res and is_nil(
                      r.action
                           ) and r.permission == ^permission,
                    preload: [:res]
        do
        nil -> {:error, :rule_not_found}
        rule -> rule
      end
    else
      case Rule
           |> Repo.repo().get_by([role: role, res_id: res, permission: permission, action: action])
        do
        nil -> {:error, :rule_not_found}
        rule -> rule
      end
    end

  end
  def get_rule_by(%{"role" => role, "res" => res, "action" => action})do
    case Rule
         |> Repo.repo().all([role: role, res_id: res, action: action])
         |> Repo.repo().preload(:res)  do
      nil -> {:error, :rule_not_found}
      [] -> {:error, :rule_not_found}
      rule -> rule
    end
  end
  def get_rule_by(%{"role" => role, "res" => res})do
    case Repo.repo().all(Rule, [role: role, res_id: res]) do
      nil -> {:error, :rule_not_found}
      rule -> rule
    end
  end
  def get_rule_by(role) do
    case Role
         |> Repo.repo().get(role)
         |> Repo.repo().preload([{:rules, :res}])
      do
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
    |> Rule.changeset(attrs, attrs["res"])
    |> Repo.repo().insert()
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
    cs = rule
         |> Rule.u_changeset(attrs)
    if cs.changes != %{} do
      cs
      |> Repo.repo().update()
    end

  end

  @doc """
  Deletes a Rule.

  ## Examples

      iex> delete_rule(rule)
      {:ok, %Rule{}}

      iex> delete_rule(rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rule(%Rule{} = rule) do
    Repo.repo().delete(rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rule changes.

  ## Examples

      iex> change_rule(rule)
      %Ecto.Changeset{source: %Rule{}}

  """
  def change_rule(%Rule{} = rule) do
    Rule.changeset(rule, %{}, %{})
  end
end
