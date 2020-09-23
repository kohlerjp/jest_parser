defmodule JestParserTest do
  use ExUnit.Case
  doctest JestParser

  describe "JestParser.encode&/1" do
    test "correctly encodes well-formatted map" do
      jest_map = %{
        body: "Why don't eggs tell jokes?",
        punchline: "They'd crack each other up!",
        author: "Jack Pott"
      }
      expected = "Why don't eggs tell jokes?|54686579276420637261636B2065616368206F7468657220757021|Jack Pott"
      assert JestParser.encode(jest_map) == {:ok, expected}
    end

    test "returns an error when punchline can't be encoded" do
      jest_map = %{
        body: "What time did the man go to the dentist?",
        punchline: 230,
        author: "Bennie Factor"
      }
      assert JestParser.encode(jest_map) == {:error, "Punchline can not be encoded"}
    end

    test "retuns partial encoding when body is missing" do
      jest_map = %{
        punchline: "Ten Tickles",
        author: "Justin Thyme"
      }

      assert JestParser.encode(jest_map) == {:ok, "|54656E205469636B6C6573|Justin Thyme"}
    end

    test "retuns partial encoding when punchline is missing" do
      jest_map = %{
        body: "How many tickles does it take to make an octopus laugh?",
        author: "Justin Thyme"
      }
      expected = "How many tickles does it take to make an octopus laugh?||Justin Thyme"
      assert JestParser.encode(jest_map) == {:ok, expected}
    end

    test "returns partial encoding when no values are given" do
      jest_map = %{}
      assert JestParser.encode(jest_map) == {:ok, "||"}
    end
  end

  describe "JestParser.decode&/1" do
    test "correctly decodes well-formatted Jest message" do
      message = "I don't trust stairs|5468657927726520616C7761797320757020746F20736F6D657468696E6721|Joe King"
      expected = %{
        body: "I don't trust stairs",
        punchline: "They're always up to something!",
        author: "Joe King"
      }
      assert JestParser.decode(message) == {:ok, expected}
    end

    test "decoding an encoded message" do
      jest_map = %{
        body: "Why don't eggs tell jokes?",
        punchline: "They'd crack each other up!",
        author: "Jack Pott"
      }
      {:ok, message} = JestParser.encode(jest_map)
      {:ok, decoded} = JestParser.decode(message)
      assert decoded == jest_map
    end

    test "decoding message without a body returns partial message" do
      message = "|5468656E2069742067726577206F6E206D65|Kay Oss"
      expected = %{
        body: "",
        punchline: "Then it grew on me",
        author: "Kay Oss"
      }
      assert JestParser.decode(message) == {:ok, expected}
    end

    test "decoding message without a punchline returns partial message" do
      message = "I used to hate facial hair||Kay Oss"
      expected = %{
        body: "I used to hate facial hair",
        punchline: "",
        author: "Kay Oss"
      }
      assert JestParser.decode(message) == {:ok, expected}
    end

    test "decoding message without any values returns partial message" do
      message = "||"
      expected = %{
        body: "",
        punchline: "",
        author: ""
      }
      assert JestParser.decode(message) == {:ok, expected}
    end

    test "returns error when punchline can't be decoded" do
      message = "I decided to sell my vacuum cleaner|It was just gathering dust|Jay Walker"
      assert JestParser.decode(message) == {:error, "Punchline can not be decoded"}
    end

    test "decoding message with wrong format returns an error" do
      message = "I've got a great joke about construction, but I'm still working on it."
      assert JestParser.decode(message) == {:error, "Message is not formatted correctly"}
    end

    test "decoding message with too many pipes returns an error" do
      message = "I've |got a great joke| about construction,| but I'm still working on it."
      assert JestParser.decode(message) == {:error, "Message is not formatted correctly"}
    end
  end
end
