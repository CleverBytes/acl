defmodule AclWeb.RuleController do
  use AclWeb, :controller

  alias Acl.ACL
  alias Acl.ACL.Rule

  action_fallback AclWeb.FallbackController

  def index(conn, _params) do
    rules = ACL.list_rules()
    render(conn, :index, rules: rules)
  end

  def create(conn, %{"rule" => rule_params}) do
    with {:ok, %Rule{} = rule} <- ACL.create_rule(rule_params) do
      conn
      |> put_status(:created)
      |> render(:show, rule: rule)
    end
  end

  def show(conn, %{
        "role" => role,
        "resource" => resource,
        "permission" => permission,
        "action" => action
      }) do
    rule = ACL.get_rule!([role, resource, permission, action])
    render(conn, :show, rule: rule)
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = ACL.get_rule!(id)

    with {:ok, %Rule{} = rule} <- ACL.update_rule(rule, rule_params) do
      render(conn, :show, rule: rule)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = ACL.get_rule!(id)

    with {:ok, %Rule{}} <- ACL.delete_rule(rule) do
      send_resp(conn, :no_content, "")
    end
  end

  def getRule(params) do
    params
    |> ACL.get_rule_by()
    |> case do
      nil -> {:error, "rule_doesnt_exist"}
      rule -> rule
    end
  end

  def checkRule(role, resource, action, permission) do
    case ACL.get_rule_by(role) do
      {:error, error} -> {:error, error}
      records -> iterateRules(resource, action, permission, Map.from_struct(records).rules)
    end
  end

  def iterateRules(resource, action, permission, [rule | rules]) do
    cond do
      rule.resource.resource == resource and rule.action == action and
          rule.permission >= permission(permission) ->
        formAclResponse(rule)

      rule.resource.resource == resource and rule.permission >= permission(permission) ->
        formAclResponse(rule)

      rule.resource.resource == nil and rule.permission >= permission(permission) ->
        formAclResponse(rule)

      true ->
        iterateRules(resource, action, permission, rules)
    end
  end

  def iterateRules(_resource, _action, _permission, []), do: {:error, :permission_denied}

  def formAclResponse(rule) do
    if rule.where_cond == nil or rule.where_field == nil or rule.where_value == nil do
      {
        :ok,
        %{
          "role" => rule.role,
          "resource" => rule.resource.resource,
          "condition" => condition(rule.condition),
          "permission" => permission(rule.permission),
          "$where" => %{}
        }
      }
    else
      where_clause = %{
        rule.where_field => %{
          rule.where_cond => rule.where_value
        }
      }

      {
        :ok,
        %{
          "role" => rule.role,
          "resource" => rule.resource.resource,
          "condition" => condition(rule.condition),
          "permission" => permission(rule.permission),
          "$where" => where_clause
        }
      }
    end
  end

  def permission(param) do
    case param do
      0 -> 0
      1 -> 1
      2 -> 2
      3 -> 3
      4 -> 4
      "read" -> 1
      "write" -> 2
      "delete" -> 3
      "edit" -> 4
      "none" -> 0
      _ -> nil
    end
  end

  def condition(param) do
    case param do
      0 -> "none"
      1 -> "self"
      2 -> "related"
      3 -> "all"
    end
  end

  def addRule(role, res_, permission \\ 1, action \\ nil, condition \\ 1) do
    case ACL.get_resource(res_) do
      nil -> {:error, :res_unknown}

      resource ->
        rule_ = ACL.get_rule_by(%{"role" => role, "resource" => resource.id, "action" => action})

        case rule_ do
          {:error, :rule_not_found} ->
            ACL.create_rule(%{
              "role" => role,
              "resource" => resource,
              "permission" => permission(permission),
              "action" => action,
              "condition" => condition
            })

          {:error, _} ->
            {:error, :error_occured}

          [rule | _] ->
            ACL.update_rule(
              rule,
              %{
                "role" => role,
                "resource" => resource,
                "permission" => permission(permission),
                "action" => action,
                "condition" => condition
              }
            )
        end
    end
  end

  def allowRule(%{
        "role" => role,
        "resource" => resource,
        "permission" => permission,
        "action" => action,
        "condition" => condition
      }) do
    rule =
      ACL.get_rule_by(%{
        "role" => role,
        "resource" => resource,
        "permission" => permission,
        "action" => action
      })

    if rule != nil do
      ACL.update_rule(rule, %{"allowed" => true, "condition" => condition})
      true
    else
      false
    end
  end

  def allowRule(%Rule{} = rule) do
    ACL.update_rule(rule, %{"allowed" => true})
  end

  def denyRule(%{
        "role" => role,
        "resource" => resource,
        "permission" => permission,
        "action" => action,
        "condition" => condition
      }) do
    rule =
      ACL.get_rule_by(%{
        "role" => role,
        "resource" => resource,
        "permission" => permission,
        "action" => action
      })

    if rule != nil do
      ACL.update_rule(rule, %{"allowed" => false, "condition" => condition})
      true
    else
      false
    end
  end

  def denyRule(%Rule{} = rule) do
    ACL.update_rule(rule, %{"allowed" => false})
  end
end
