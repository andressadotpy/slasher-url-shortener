defmodule Slasher.UrlsTest do
  use Slasher.DataCase

  alias Slasher.Urls

  describe "links" do
    alias Slasher.Urls.Link

    @valid_attrs %{date: "some date", long_url: "some long_url", short_url: "some short_url"}
    @update_attrs %{date: "some updated date", long_url: "some updated long_url", short_url: "some updated short_url"}
    @invalid_attrs %{date: nil, long_url: nil, short_url: nil}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Urls.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Urls.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Urls.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = Urls.create_link(@valid_attrs)
      assert link.date == "some date"
      assert link.long_url == "some long_url"
      assert link.short_url == "some short_url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Urls.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, %Link{} = link} = Urls.update_link(link, @update_attrs)
      assert link.date == "some updated date"
      assert link.long_url == "some updated long_url"
      assert link.short_url == "some updated short_url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Urls.update_link(link, @invalid_attrs)
      assert link == Urls.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Urls.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Urls.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Urls.change_link(link)
    end
  end
end
