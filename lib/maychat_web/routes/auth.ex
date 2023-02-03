defmodule MaychatWeb.Routes.Auth do
  @moduledoc """
  Authentication controller.
  """
  use Plug.Router
  require Logger

  plug(:match)

  plug(Plug.Parsers,
    pass: ["text/html", "application/json"],
    parsers: [{:json, json_decoder: Jason}]
  )

  plug(:dispatch)

  # TODO: Make these routes call the appropiate controllers
  # TODO: Make JWT Authentication

  alias Maychat.Contexts.Users
  alias Maychat.Schemas.User

  post "/register" do
    {:ok, form_params, conn} = extract_auth_params_from_conn(conn)

    Logger.info("Received body_params #{inspect(conn.body_params)}")

    case Users.register(form_params) do
      {:ok, %User{id: user_id}} ->
        # TODO: Log the user in after successful registration
        # {:ok, user} = Users.login(form_params)

        # TODO: Return user information both in login a register
        res_body = %{
          "user_id" => user_id,
          success: true
        }

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(res_body))

      {:error, %Ecto.Changeset{errors: errors} = changeset} ->
        # Remember removing this
        Logger.error("Error on Users.register/1: #{inspect(errors)}")

        if changeset.valid? == false do
          errors_map = %{
            "errors" =>
              changeset
              |> Ecto.Changeset.traverse_errors(fn {msg, _opts} ->
                msg
              end)
          }

          conn
          |> put_resp_content_type("application/json")
          |> send_resp(400, Jason.encode!(Map.merge(errors_map, %{success: false})))
        end
    end
  end

  post "/login" do
    # Do Login
    conn
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end

  # Constructs a map containing at least the params required for User schema
  # Other fields are logged but ignored.
  defp extract_auth_params_from_conn(conn) do
    # body_params = %{
    #   "test1" => "test1",
    #   "test2" => 1000,
    #   "test3" => %{"test3_1" => ["test", "hello"]}
    # }
    %Plug.Conn{
      body_params: body_params
    } = conn

    {:ok,
     %{
       username: body_params["username"],
       email: body_params["email"],
       password: body_params["password"],
       password_confirmation: body_params["password_confirmation"],
       avatar_url: body_params["avatar_url"]
     }, conn}
  end
end
