import Config

config :maychat, ecto_repos: [Maychat.Repo]

config :maychat, Maychat.Repo,
  host: "localhost",
  database: "maychat_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
