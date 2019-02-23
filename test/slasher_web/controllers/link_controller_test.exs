defmodule SlasherWeb.LinkControllerTest do
  use SlasherWeb.ConnCase

  alias Slasher.Urls

  @create_attrs %{date: "some date", long_url: "some long_url", short_url: "some short_url"}
  @update_attrs %{
    date: "some updated date",
    long_url: "some updated long_url",
    short_url: "some updated short_url"
  }
  @invalid_attrs %{date: nil, long_url: nil, short_url: nil}

  def fixture(:link) do
    {:ok, link} = Urls.create_link(@create_attrs)
    link
  end

  describe "index" do
    test "lists all links", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Links"
    end
  end

  describe "new link" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.link_path(conn, :new))
      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "create link" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.link_path(conn, :show, id)

      conn = get(conn, Routes.link_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Link"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.link_path(conn, :create), link: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Link"
    end
  end

  describe "edit link" do
    setup [:create_link]

    test "renders form for editing chosen link", %{conn: conn, link: link} do
      conn = get(conn, Routes.link_path(conn, :edit, link))
      assert html_response(conn, 200) =~ "Edit Link"
    end
  end

  describe "update link" do
    setup [:create_link]

    test "redirects when data is valid", %{conn: conn, link: link} do
      conn = put(conn, Routes.link_path(conn, :update, link), link: @update_attrs)
      assert redirected_to(conn) == Routes.link_path(conn, :show, link)

      conn = get(conn, Routes.link_path(conn, :show, link))
      assert html_response(conn, 200) =~ "some updated date"
    end

    test "renders errors when data is invalid", %{conn: conn, link: link} do
      conn = put(conn, Routes.link_path(conn, :update, link), link: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Link"
    end
  end

  describe "delete link" do
    setup [:create_link]

    test "deletes chosen link", %{conn: conn, link: link} do
      conn = delete(conn, Routes.link_path(conn, :delete, link))
      assert redirected_to(conn) == Routes.link_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.link_path(conn, :show, link))
      end
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    {:ok, link: link}
  end

  # tests if the shortened url is in fact shorter than the original url
  test "it outputs a shorter URL than the one provided", %{conn: conn} do
    original = "http://www.example.com/a-long-url/that-for-sure-will-be-shortened"
    conn = post(conn, "/", url: original)
    [location | _] = get_resp_header(conn, "location")
    assert String.length(location) < String.length(original)
  end

  # if the converted url is longer than the original, returns the original
  # @tag :skip
  test "it outputs the original URL if the shorter URL isn't", %{conn: conn} do
    original = "a.b"
    conn = post(conn, "/", url: original)
    [location | _] = get_resp_header(conn, "location")
    assert location === original
  end

  # @tag :skip
  test "it redirects to the long URL when given a shortened URL", %{conn: conn} do
    original = "http://www.example.com/a-long-url/that-for-sure-will-be-shortened"
    conn = post(conn, "/", url: original)
    [location | _] = get_resp_header(conn, "location")

    conn = get(conn, "/", shortened: location)
    assert redirected_to(conn, 200) == original
  end

  # @tag :skip
  test "it outputs different short URLs for different long URLs", %{conn: conn} do
    first = "http://www.example.com/a-long-url/that-for-sure-will-be-shortened"
    conn = post(conn, "/", url: first)
    [first_url | _] = get_resp_header(conn, "location")

    second = "http://www.example.com/a-different-url/#{Enum.random(1..10_000)}"
    conn = post(conn, "/", url: second)
    [second_url | _] = get_resp_header(conn, "location")

    assert first_url !== second_url, "short URLs should be different but are the same"
  end

  # makes sure that it's returning the same hash for the same input
  # @tag :skip
  test "a long URL always generates the same short URL", %{conn: conn} do
    first = "http://www.example.com/a-long-url/that-for-sure-will-be-shortened"
    conn = post(conn, "/", url: first)
    [first_url | _] = get_resp_header(conn, "location")

    second = "http://www.example.com/a-long-url/that-for-sure-will-be-shortened"
    conn = post(conn, "/", url: second)
    [second_url | _] = get_resp_header(conn, "location")

    assert first_url === second_url
  end

  # @tag :skip
  test "deleting a short URL stops redirecting to the long URL", %{conn: conn} do
    original = "http://www.example.com/some-long-url"

    conn = post(conn, "/", %{"url" => original})
    [short_url | _] = get_resp_header(conn, "location")

    conn = delete(conn, "/", %{"shortened" => short_url})

    conn = get(conn, "/", %{"shortened" => short_url})
    assert conn.status === 404
  end

  # @tag :skip
  test "a recreated short URL creates the same short URL as before", %{conn: conn} do
    original = "http://www.example.com/some-long-url"

    conn = post(conn, "/", %{"url" => original})
    [short_url | _] = get_resp_header(conn, "location")

    conn = delete(conn, "/", %{"shortened" => short_url})

    conn = post(conn, "/", %{"url" => original})
    [recreated_url | _] = get_resp_header(conn, "location")

    assert short_url === recreated_url
  end
end
