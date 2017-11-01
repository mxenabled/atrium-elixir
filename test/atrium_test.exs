defmodule AtriumTest do
  use ExUnit.Case
  doctest Atrium

  test "greets the world" do
    assert Atrium.hello() == :world
  end
end
