defmodule Acl do
  alias AclWeb.RuleController
  alias AclWeb.RoleController
  alias AclWeb.ResController

@moduledoc """
# Acl

ACL or access control list is a list of permissions attached to a specific object for certain users.
This ACL is designed to be used in a phoneix (Elixir) project and handles all your permissions managment.
 It requires following depedencies



      {:ecto_sql, "\~> 3.0"}
      {:jason, "\~> 1.0"}
      {:plug_cowboy, "\~> 1.0.0"}
      {:ex_doc, ">= 0.0.0", only: :dev}
      {:phoenix, "\~> 1.3.0"}
      {:phoenix_pubsub, "\~> 1.0"}
      {:phoenix_ecto, "\~> 3.2"}
      {:postgrex, ">= 0.0.0"}
      {:phoenix_html, "\~> 2.10"}
      {:phoenix_live_reload, "\~> 1.0", only: :dev}
      {:gettext, "\~> 0.11"}
      {:cowboy, "\~> 1.0"}



## Installation guide

To add ACL to your project simpley add to your projects depedencies



    {:acl, "~> 0.4.0"}


and run "mix deps.get"
thn you need to add :acl to your application
and also add configuration for :acl in your config file

    config :acl, Acl.Repo,
       repo: MyApp.Repo

you also need to run migrations for acl, which creates tables required for the acl, you can find migrations inside acl folder in your deps directory.


## ACL guide

it has three essential Componenets Roles,Resources (handles as res), and Rules.

### Roles

Roles (users/user groups) are entities you want to give or deny access to.
you can add a new role by



    Acl.addRole(%{"role" => "role", "parent" => "parent"})



in roles parent is optional and you may choose to provide it or not.

### Res

Res  are entities you want to give or deny access for. they can be anything real or arbitaray.

you can add a new res by



    Acl.addRes(%{"res" => "res", "parent" => "parent"})



in res parent is optional and you may choose to provide it or not.

### Rules

Rules are definition for your set of permissions. you can add rule by



    addRule(role, res,  permission \\1, action \\nil ,condition \\1 )


and you can check if a role or permission exists by



    hasAccess(role, permission \\"read", res \\nil, action \\nil)



valid inputs for permmission are "POST","GET","PUT" ,"DELETE","read","write","delete","edit". permissions have downword flow. i.e if you have defined permissions for a higher operation it automatically assings them permissions for lower operations.
like "edit" grants permissions for all operations. their heirarchy is in this order



    "read" < "write" < "delete" < "edit"
    "GET" < "POST" < "DELETE" < "PUT"



you can use actions argument to define actions for your resources or not use thema t all and skip sending them in arguments. like i have a resource as maps and i can define actions like display/resize etc. now actions can be pages in a web application or can be tables for an api or can be functions inside a controller. you can be as creative as you wish

and last argument condition is to define permission levels (0,1,2,3), and they map in this order.



    0 -> "none"
    1 -> "self"
    2 -> "related"
    3 -> "all"



you can add a res with empity string and it will be used as super resource. granting permission to that resource is equivalent to making a superadmin and any role who have access to this resource will have all permissions.


##### for issues pls open an issue
"""

@doc false
  def hasAccess(role, permission \\"read", res \\nil, action \\nil) do
    RuleController.checkRule(role, res, action, permissionTranslate(permission))
  end
  @doc false

  def addRule( role,res,  permission \\1, action \\nil ,condition \\1 ) do

    RuleController.addRule(role, res,  permission , action , condition )
  end
  @doc false

  def getRule( params) do

    RuleController.getRule(params)
  end
  @doc false

  def addRole( params) do

    RoleController.create(params)
  end
  @doc false

  def addRes( params) do

    ResController.create(params)
  end
  @doc false

  def allowAccess( %{__struct__: _} = rule) do

    case RuleController.allowRule(rule) do
      true -> {:ok, :allowed}
      false -> {:error, "rule not found, perhaps create new rule?"}
    end
  end
  @doc false

  def allowAccess(conn, params) do

    case RuleController.allowRule(params) do
      true -> {:ok, :allowed}
      false -> {:error, "rule not found, perhaps create new rule?"}
    end
  end
  @doc false

  def denyAccess(conn, %{__struct__: _}  = rule) do

    case RuleController.denyRule(rule) do
      true -> {:ok, :denied}
      false -> {:error, "rule not found, perhaps create new rule?"}
    end
  end
  @doc false

  def denyAccess(conn, params) do

    case RuleController.denyRule(params) do
      true -> {:ok, :denied}
      false -> {:error, "rule not found, perhaps create new rule?"}
    end
  end
  @doc false

  defp permissionTranslate (permission) do
    case permission do
      "POST" -> "write"
      "GET" -> "read"
      "PUT" -> "edit"
      "DELETE" -> "delete"
      "write" -> "write"
      "read" -> "read"
      "edit" -> "edit"
      "delete" -> "delete"
      _ -> nil
    end

  end

end
