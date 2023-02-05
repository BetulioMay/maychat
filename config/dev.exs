import Config

config :maychat, Maychat.Repo,
  host: "localhost",
  database: "maychat_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :maychat,
  ecto_repos: [Maychat.Repo]

# access_token_secret:
#   System.get_env("ACCESS_TOKEN_SECRET") ||
#     raise("""
#       ACCESS_TOKEN_SECRET env is not set.
#     """),
# refresh_token_secret:
#   System.get_env("REFRESH_TOKEN_SECRET") ||
#     raise("""
#       REFRESH_TOKEN_SECRET env is not set.
#     """)

config :maychat, Maychat.Guardian,
  issuer: "maychat",
  # REMINDER, make this env variable been fetched! from system in prod
  secret_key:
    System.get_env("GUARDIAN_SECRET_KEY") ||
      "5eaPUlTNdvtY2BientH1adI5fFunh538PUppnDan/fmTXYvZkBF8IG7wdqFM9j1Q"

# config :joken,
#   access_token_secret: System.fetch_env!("ACCESS_TOKEN_SECRET"),
#   refresh_token_secret: System.fetch_env!("REFRESH_TOKEN_SECRET")
