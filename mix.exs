defmodule Acl.MixProject do
  use Mix.Project

  def project do
    [
      app: :acl,
      version: "0.4.1",
      elixir: "~> 1.5",
      maintainers: ["Azwar Habib"],
      licenses: ["Apache 2.0"],
      description: "Acl implementation.",
      links: %{"GitHub" => "https://github.com/CleverBytes/acl"},
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),
      name: "ACL",
      source_url: "https://github.com/CleverBytes/acl",
      homepage_url: "https://github.com/CleverBytes/acl",
      docs: [main: "Acl", # The main page in the docs
        extras: ["README.md"],
                api_reference: false,
      ]
    ]
  end
  defp description do
    """
    Acl implementation.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Azwar Habib"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/CleverBytes/acl"},
      description: "Acl implementation."

    ]
  end
  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Acl.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end



end
