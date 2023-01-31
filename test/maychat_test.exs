defmodule MaychatTest do
  use ExUnit.Case
  doctest Maychat

  test "greets the world" do
    assert Maychat.hello() == :world
  end
end
