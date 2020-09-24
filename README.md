# JestParser

JestParser is a library that provides functionality for encoding and decoding
messages in the JESt format.

## Installation

This library is available through github. To add `jest_parser` to your project,
add the following to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jest_parser, git: "https://github.com/kohlerjp/jest_parser.git", tag: "0.1"}
  ]
end
```

## Usage
Once the library has been added to your project,
the `JestParser.encode/1` and `JestParser.decode/1` functions become available.

### Encode
The encode function will take a map containing a body, punchline, and author,
and will return a tuple containing the encoding status and the encoded message.

```elixir
joke = %{body: "I used to hate facial hair",
         punchline: "But then it grew on me!",
         author: "Joe King"}
JestParser.encode(joke)
# => {:ok, "I used to hate facial hair|427574207468656E2069742067726577206F6E206D6521|Joe King"}
```

An `encode!/1` function is also available, which only returns the message, and will raise
an error if the joke cannot be encoded.

### Decode
The decode function takes a message encoded in JESt format and will return a map
containing the body, punchline, and author.

```elixir
message = "I used to hate facial hair|427574207468656E2069742067726577206F6E206D6521|Joe King"
JestParser.decode(message)

# =>{:ok, %{body: "I used to hate facial hair", punchline: "But then it grew on me!", author: "Joe King"}}
```

Just as with `encode`, there is a `decode!/1` function which only returns the map.
