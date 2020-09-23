defmodule JestParserTest do
  use ExUnit.Case
  doctest JestParser

  test "greets the world" do
    assert JestParser.hello() == :world
  end
end
