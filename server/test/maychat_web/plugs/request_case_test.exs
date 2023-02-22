defmodule MaychatWeb.Plugs.RequestCaseTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Recase.SnakeCase
  alias MaychatWeb.Plugs.RequestCase

  @some_params %{
    username: "cesarMay",
    email: "some-email",
    password: "some_Password",
    passwordConfirmation: "some_Password"
  }

  setup_all do
    conn = conn(:get, "/some/route", @some_params)
    opts = RequestCase.init(case: SnakeCase)
    {:ok, conn: %{conn | body_params: conn.params}, opts: opts}
  end

  describe "Plugs.RequestCase" do
    test "should snake passwordConfirmation", %{conn: conn, opts: opts} do
      conn =
        conn
        |> RequestCase.call(opts)

      assert Map.has_key?(conn.body_params, "password_confirmation")
      # Check if key has not been expanded, a new map is created instead
      refute Map.has_key?(conn.body_params, "passwordConfirmation")
    end

    test "should snake without predefined case option", %{conn: conn} do
      default_opts = RequestCase.init([])

      conn =
        conn
        |> RequestCase.call(default_opts)

      # Has snaked successfully
      assert Map.has_key?(conn.body_params, "password_confirmation")
      refute Map.has_key?(conn.body_params, "passwordConfirmation")
    end

    test "should not modify a value", %{conn: conn, opts: opts} do
      %{
        "username" => username,
        "email" => email,
        "password" => password,
        "passwordConfirmation" => confirmation
      } = conn.body_params

      conn =
        conn
        |> RequestCase.call(opts)

      assert conn.body_params["username"] == username
      assert conn.body_params["email"] == email
      assert conn.body_params["password"] == password
      assert conn.body_params["password_confirmation"] == confirmation
    end
  end
end
