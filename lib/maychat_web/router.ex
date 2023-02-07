defmodule MaychatWeb.Router do
  @moduledoc false

  use Plug.Router
  use Plug.ErrorHandler

  alias MaychatWeb.Routes
  import MaychatWeb.Utils.Errors

  defmodule EndpointNotFound do
    defexception message:
                   Jason.encode!(%{success: false, errors: normalize_string_err("Not found")}),
                 plug_status: 404

    @impl true
    def exception(path) do
      msg = "Path #{path} Not Found"

      %__MODULE__{
        message:
          Jason.encode!(%{
            success: false,
            errors: normalize_string_err(msg)
          })
      }
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
    raise(EndpointNotFound, ["/" | conn.path_info] |> Path.join())

    # Avoid annoying warning because of unused conn
    conn
  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    conn
    |> send_resp(conn.status, reason.message)
  end
end
