# Acl

ACL or access control list is a list of permissions attached to a specific object for certain users.
This ACL is designed to be used in a phoenix (Elixir) project and handles all your permissions management.
 It requires following dependencies
 
 
 
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

To add ACL to your project simply add to your projects dependencies



    {:acl, "~> 0.4.0"}


and run "mix deps.get"
then you need to add :acl to your application
and also add configuration for :acl in your config file
    
    config :acl, Acl.Repo,
       repo: MyApp.Repo
    
you also need to run migrations for acl, which creates tables required for the acl, you can find migrations inside acl folder in your deps directory.


## ACL guide

it has three essential Components Roles,Resources (handles as res), and Rules.

### Roles

Roles (users/user groups) are entities you want to give or deny access to. 
you can add a new role by



    Acl.addRole(%{"role" => "role", "parent" => "parent"})



in roles parent is optional and you may choose to provide it or not.

### Res

Res  are entities you want to give or deny access for. they can be anything real or arbitrary.

you can add a new res by



    Acl.addRes(%{"res" => "res", "parent" => "parent"})



in res parent is optional and you may choose to provide it or not.

### Rules

Rules are definition for your set of permissions. you can add rule by



    addRule(role, res,  permission \\1, action \\nil ,condition \\1 )


and you can check if a role or permission exists by 



    hasAccess(role, permission \\"read", res \\nil, action \\nil)



valid inputs for permission are "POST","GET","PUT" ,"DELETE","read","write","delete","edit". permissions have downward flow. i.e if you have defined permissions for a higher operation it automatically assigns them permissions for lower operations.
like "edit" grants permissions for all operations. their hierarchy is in this order



    "read" < "write" < "delete" < "edit"
    "GET" < "POST" < "DELETE" < "PUT"



you can use actions argument to define actions for your resources or not use them at all and skip sending them in arguments. like i have a resource as maps and i can define actions like display/resize etc. now actions can be pages in a web application or can be tables for an api or can be functions inside a controller. you can be as creative as you wish

and last argument condition is to define permission levels (0,1,2,3), and they map in this order.



    0 -> "none"
    1 -> "self"
    2 -> "related"
    3 -> "all"
      


you can add a res with empty string and it will be used as super resource. granting permission to that resource is equivalent to making a super admin and any role who have access to this resource will have all permissions.


##### for issues pls open an issue




