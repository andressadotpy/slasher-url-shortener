defmodule SlasherWeb.LinkController do
  use SlasherWeb, :controller

  alias Slasher.Repo
  alias Slasher.Urls.Link
  alias Slasher.Urls
  alias Slasher.SlasherCode

  def new(conn, _params) do
    changeset = Link.new()
    render(conn, "new.html", changeset: changeset)
  end

  def index(conn, _params) do
    links = Urls.list_link!()
    render(conn, "index.html", links: links)
  end

  def get_long_url(conn, %{"id" => short_url}) do
    case lengthen(short_url) do
      {:error, _} ->
        put_status(conn, :not_found)
        |> text("Not found")

      {:ok, long_url} ->
        redirect(conn, external: long_url)
    end
  end

  def make_short_url(conn, %{"url" => long_url}) do
    short_url = SlasherCode.shorten(long_url)

    put_resp_header(conn, "location", short_url)
    |> put_status(:created)
    |> text("")
  end

  def show(conn, %{"id" => short_url}) do
    link = Repo.get(Link, short_url)
    render(conn, "show.html", link: link)
  end

  def delete_short_url(conn, %{"slashercode" => short_url}) do
    case Repo.get_by(Link, short_url: short_url) do
      nil ->
        {:error, "Not found"}

      url ->
        Repo.delete!(url)
        :ok
    end

    render(conn, "index.html")
  end

  def lengthen(short_url) do
    case Repo.get_by(Link, short_url: short_url) do
      nil ->
        {:error, "Not found"}

      url ->
        {:ok, url.long_url}
    end
  end
end
