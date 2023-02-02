defmodule Maychat.MixProject do
  use Mix.Project

  def project do
    [
      app: :maychat,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Maychat.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:plug, "~> 1.13"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.3"},
      {:argon2_elixir, "~> 3.0"}
    ]
  end

  defp aliases do
    [
      "ecto.mount": ["ecto.create", "ecto.migrate"],
      "ecto.remount": ["ecto.drop", "ecto.mount"],
      test: ["ecto.drop", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
