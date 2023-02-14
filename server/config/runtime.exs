import Config

config :iex, default_prompt: "maychat>"

config :maychat,
  port: System.get_env("PORT")
