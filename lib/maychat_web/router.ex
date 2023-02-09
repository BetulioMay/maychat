defmodule MaychatWeb.Router do
  @moduledoc false

  use Plug.Router
  use Plug.ErrorHandler

  alias MaychatWeb.Routes
  alias MaychatWeb.Utils.Errors.NormalizeError
  alias MaychatWeb.Pipes

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

  plug(:match)

  plug(Pipes.EnsureAuth, paths: ["/protected"])

  plug(:dispatch)

  forward("/auth", to: Routes.Auth)
  forward("/user", to: Routes.User)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  get "/protected" do
    conn
    |> send_resp(200, "How is it going?!")
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
