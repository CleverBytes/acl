defmodule AclWeb.RuleJSON do
  alias Acl.ACL.Rule

  @doc """
  Renders a list of rules.
  """
  def index(%{rules: rules}) do
    %{data: for(rule <- rules, do: data(rule))}
  end

  @doc """
  Renders a single rule.
  """
  def show(%{rule: rule}) do
    %{data: data(rule)}
  end

  defp data(%Rule{} = rule) do
    %{
      role: rule.role,
      res: rule.resource,
      action: rule.action,
      allowed: rule.allowed,
      permission: rule.permission
    }
  end
end
