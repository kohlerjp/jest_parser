defmodule JestParser do
  @moduledoc """
  A module to handle encoding and decoding JEst style messages
  """

  @doc "Encodes a map to JESt format. Returns tuple of {status, message}"
  def encode(jest_map) do
    body = Map.get(jest_map, :body)
    punchline = Map.get(jest_map, :punchline)
    author = Map.get(jest_map, :author)

    do_encode(body, punchline, author)
  end

  @doc "Encodes a map to JESt format. Raises Arguemnt error when map cannot be parsed"
  def encode!(jest_map) do
    case encode(jest_map) do
      {:ok, message} -> message
      _ -> raise ArgumentError, message: "Given invalid map"
    end
  end

  @doc "Decodes a JESt message to a map containing body, punchline, and author."
  def decode(jest_string) do
    case String.split(jest_string, "|") do
      [body, encoded_punchline, author] ->
        do_decode(body, encoded_punchline, author)
      _ ->
        {:error, "Message is not formatted correctly"}
    end
  end

  @doc """
  Decodes a JESt message to a map containing body, punchline, and author.
  Raises ArgumentError when message cannot be decoded
  """
  def decode!(message) do
    case decode(message) do
      {:ok, map} -> map
      _ -> raise ArgumentError, message: "Given invalid message"
    end
  end

  defp do_encode(body, punchline, author) do
    case encode_punchline(punchline) do
      {:ok, encoded} -> {:ok, "#{body}|#{encoded}|#{author}"}
      {:error, message} -> {:error, message}
    end
  end

  defp encode_punchline(nil) do
    {:ok, ""}
  end
  defp encode_punchline(punchline) do
    try do
      {:ok, Base.encode16(punchline)}
    rescue
      _ -> {:error, "Punchline can not be encoded"}
    end
  end

  defp do_decode(body, encoded_punchline, author) do
    case Base.decode16(encoded_punchline) do
      {:ok, punchline} -> {:ok, %{body: body, punchline: punchline, author: author}}
      _ -> {:error, "Punchline can not be decoded"}
    end
  end
end
