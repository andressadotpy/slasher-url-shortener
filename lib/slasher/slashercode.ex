defmodule Slasher.SlasherCode do
  alias Slasher.Repo

  @doc """
  shorten receives a long_url, hash the long_url using Murmur. Murmur returns
  a 32 bit integer; using the erlang function base 36 converter integer_to_binary,
  the returned short url can have numbers and letters.
  """
  def shorten(long_url) do
    hash_value = Murmur.hash_x86_32(long_url)
    short_url = :erlang.integer_to_binary(hash_value, 36)
    short_url = "/" <> short_url

    case String.length(short_url) < String.length(long_url) do
      true ->
        Repo.insert!(short_url: short_url, long_url: long_url)
        short_url

      _ ->
        long_url
    end
  end
end
