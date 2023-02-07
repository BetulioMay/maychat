defmodule MaychatWeb.Router do
  @moduledoc false

  use Plug.Router
  use Plug.ErrorHandler

  alias MaychatWeb.Routes
  alias MaychatWeb.Utils.Errors.NormalizeError

  defmodule EndpointNotFoundError do
    defexception [:message, plug_status: 404]

    @impl true
    def exception(path_info) do
      msg = "Path #{["/" | path_info] |> Path.join()} Not Found"

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
  plug(:dispatch)

  forward("/auth", to: Routes.Auth)
  forward("/user", to: Routes.User)

  get "/hello" do
    send_resp(conn, 200, "world")
  end

  match _ do
    raise(EndpointNotFoundError, conn.path)
    # Avoid annoying warning because of unused conn
    conn
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    conn
    |> send_resp(conn.status, reason.message)
  end
end
