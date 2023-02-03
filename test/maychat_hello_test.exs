defmodule MaychatHelloTest do
  use ExUnit.Case
  doctest Maychat

  test "greets the world" do
    assert MaychatHello.hello() == :world
  end
end
