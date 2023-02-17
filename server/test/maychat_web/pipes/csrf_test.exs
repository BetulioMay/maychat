defmodule MaychatWeb.Pipes.CSRFTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias MaychatWeb.Plugs.Pipes

  @some_sensible_path "/auth/login"

  setup do
    {:ok, login_conn: conn(:post, @some_sensible_path, nil)}
  end

  describe "Pipes.CSRF" do
    test "csrf token is valid when the same session", %{login_conn: conn} do
      conn =
        conn
        |> Pipes.CSRF.call([])
        |> fetch_session()

      assert get_req_header(conn, "x-csrf-token") != nil
      assert get_session(conn, "_csrf_token") != nil
    end

    test "csrf tokens differs from sessions", %{login_conn: conn} do
      other = conn(:post, @some_sensible_path, nil)

      conn =
        conn
        |> Pipes.CSRF.call([])

      # Fork another process to avoid overriding the current process dictionary
      other = Task.async(fn -> other |> Pipes.CSRF.call([]) end) |> Task.await()

      refute get_req_header(conn, "x-csrf-token") == get_req_header(other, "x-csrf-token")
    end
  end
end
