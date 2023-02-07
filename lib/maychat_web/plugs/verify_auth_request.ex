defmodule MaychatWeb.Plugs.VerifyAuthRequest do
  @moduledoc """
  Middleware that validates if, for _auth_ paths, the request has the
  valid params. Params are sent in JSON Format in the body
  """
  defmodule InvalidRegistrationParams do
    @moduledoc """
    Exception that is raised when registration params from a connection
    are invalid (nil)

    Required params:
      - username
      - email
      - password
      - password_confirmation
    """
    defexception message: "registration params are invalid"
  end

  defmodule InvalidLoginParams do
    @moduledoc """
    Exception that is raised when login params from a connection are invalid (nil)

    Required params:
      - username_email
      - password
    """
    defexception message: "login params are invalid"
  end

  def init(opts), do: opts

  def call(conn = %Plug.Conn{request_path: path}, opts) do
    # Check if /register is in path
    if path in opts[:paths] do
      cond do
        path == "/register" ->
          verify_registration!(conn.body_params)

        path == "/login" ->
          conn
      end

      conn
    else
      conn
    end
  end

  defp verify_registration!(params) do
    # params = %{
    #   "test1" => "test1",
    #   "test2" => 1000,
    #   "test3" => %{"test3_1" => ["test", "hello"]}
    # }
    unless params
           |> Enum.all?(fn {k, _v} ->
             # Because is a map, keys are not repeated.
             # Therefore,
             k in ~w(username email password password_confirmation)
           end),
           do: raise(InvalidRegistrationParams)
  end

  # Constructs a map containing at least the params required for User schema
  # Other fields are logged but ignored.
  defp extract_register_params_from_conn(conn) do
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
