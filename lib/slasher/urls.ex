defmodule Slasher.Urls do
  import Ecto.Query, warn: false

  alias Slasher.Repo
  alias Slasher.Urls.Link

  def list_link! do
    Link
    |> Repo.all()
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
