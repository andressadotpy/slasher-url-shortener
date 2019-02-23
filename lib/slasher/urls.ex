defmodule Slasher.Urls do
  import Ecto.Query, warn: false

  alias Slasher.Repo
  alias Slasher.Urls.Link

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
        Repo.insert!(%Link{short_url: short_url, long_url: long_url})
        short_url

      _ ->
        long_url
    end
  end

  def lengthen(short_url) do
    case Repo.get_by(Link, short_url: short_url) do
      nil ->
        {:error, "Not found"}

      url ->
        {:ok, url.long_url}
    end
  end

  def delete_short_url(short_url) do
    case Repo.get_by(Link, short_url: short_url) do
      nil ->
        {:error, "Not found"}

      url ->
        Repo.delete!(url)
        :ok
    end
  end

  def list_link! do
    Link
    |> Repo.all()
    |> preload_user()
  end

  def get_link!(id), do: Repo.get!(Link, id)

  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end
end
