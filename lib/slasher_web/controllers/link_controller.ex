defmodule SlasherWeb.LinkController do
  use SlasherWeb, :controller

  alias Slasher.Urls

  def index(conn, _params) do
    links = Urls.list_link!()
    render(conn, "index.html", links: links)
  end

  def get_long_url(conn, %{"id" => short_url}) do
    case Urls.lengthen(short_url) do
      {:error, _} ->
        put_status(conn, :not_found)
        |> text("Not found")

      {:ok, long_url} ->
        redirect(conn, external: long_url)
    end
  end

  def make_short_url(conn, %{"url" => long_url}) do
    short_url = Urls.shorten(long_url)

    put_resp_header(conn, "location", short_url)
    |> put_status(:created)
    |> text("")
  end

  def delete_short_url(conn, %{"shortened" => short_url}) do
    Urls.delete_short_url(short_url)
    render(conn, "index.html")
  end
end
