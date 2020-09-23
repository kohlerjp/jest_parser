defmodule JestParser do
  @moduledoc """
  A module to handle encoding and decoding JEst style messages
  """

  def encode(%{body: body, punchline: punchline, author: author}) do
    {:ok, "#{body}|#{Base.encode16(punchline)}|#{author}"}
  end

  def decode(jest_string) do
    [body, encoded_punchline, author] = String.split(jest_string, "|")
    # handle error
    {:ok, punchline} = Base.decode16(encoded_punchline)
    {:ok, %{body: body, punchline: punchline, author: author}}
  end

end
