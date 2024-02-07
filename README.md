# Acl

ACL or access control list is a list of permissions attached to a specific object for certain users.
This ACL is designed to be used in a phoenix (Elixir) project and handles all your permissions management.
 It requires following dependencies
 
 
 
      {:ecto_sql, "\~> 3.10"}  
      {:jason, "\~> 1.2"}
      {:plug_cowboy, "\~> 1.0.0"}
      {:ex_doc, ">= 0.0.0", only: :dev}
      {:phoenix, "\~> 1.7.10"}
      {:phoenix_ecto, "\~> 4.4"}
      {:postgrex, ">= 0.0.0"}
      {:phoenix_html, "\~> 3.3"}
      {:phoenix_live_reload, "\~> 1.2", only: :dev}
      {:gettext, "\~> 0.20"}
      {:plug_cowboy, "~> 2.5"}
      


## Installation guide

To add ACL to your project simply add to your projects dependencies



    {:acl, "~> 0.5.0"}


and run `mix deps.get`
then you need to add :acl to your application in `mix.exs`

    def application do
    [
      extra_applications: [:acl]
    ]
    end

and also add configuration for :acl in your config file
    
    config :acl, Acl.Repo,
       repo: MyApp.Repo
    
you also need to run migrations for acl, which creates tables required for the acl, you can find migrations inside acl folder in your deps directory.
or update your aliases function in mix.exs

    "ecto.setup": ["ecto.create", "acl.migrate", "ecto.migrate", "run priv/repo/seeds.exs"],
    "acl.migrate": ["ecto.migrate --migrations-path deps/acl/priv/repo/migrations"],
    "ecto.migrate": ["ecto.migrate --migrations-path ./"],

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
