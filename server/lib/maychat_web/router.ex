defmodule MaychatWeb.Router do
  @moduledoc false

  use Plug.Router
  use Plug.ErrorHandler

  alias MaychatWeb.Routes
  alias MaychatWeb.Utils.Errors.NormalizeError
  alias MaychatWeb.{Plugs.Pipes, Plugs}

  defmodule PathNotFoundError do
    defexception [:message, plug_status: 404]

    @impl true
    def exception(req_path) do
      msg = "Path #{req_path} not found"

      err_payload = %{
        success: false,
        errors: NormalizeError.normalize(msg, "req_path")
      }

      %__MODULE__{message: Jason.encode!(err_payload)}
    end
  end

  if Mix.env() == :dev do
    use Plug.Debugger

    plug(Plug.Logger, log: :debug)
  else
    plug(Plug.Logger, log: :info)
  end

  plug(Plug.Parsers,
    pass: ["text/plain", "application/json"],
    parsers: [{:json, json_decoder: Jason}]
  )

  # Cors middleware
  plug(Plugs.Cors)

  # CSRF protection
  plug(Pipes.CSRF)

  plug(:match)

  # NOTE: this obviously is for testing purposes
  plug(Pipes.EnsureAuth, paths: ["/protected"])

  plug(:dispatch)

  # CORS OPTIONS request to be successful
  options _ do
    conn
    |> send_resp(200, "")
  end

  forward("/auth", to: Routes.Auth)
  forward("/user", to: Routes.User)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/protected" do
    user = Guardian.Plug.current_resource(conn)

    IO.inspect(user)

    conn
    |> send_resp(200, "How is it going, #{user.username}?!")
  end

  match _ do
    %Plug.Conn{request_path: req_path} = conn
    raise(PathNotFoundError, req_path)
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: kind, reason: reason, stack: _stack}) do
    IO.inspect(kind)
    IO.inspect(reason)

    conn
    |> send_resp(conn.status, reason.message)
  end
end
