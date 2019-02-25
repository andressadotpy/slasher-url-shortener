defmodule Slasher.Urls.Link do
  @moduledoc """
  Stores the long_url and it's short_url.
  Every long_url and short_url it's associated with the user
  that created the link.
  Date stores information about Day/Month/Year that was created the link.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Slasher.SlasherCode
  alias __MODULE__

  schema "links" do
    field :date, :string
    field :long_url, :string
    field :short_url, :string
    belongs_to :user, Slasher.Accounts.User

    timestamps()
  end

  @required_fields ~w(long_url user_id)a

  def new do
    cast(%Link{}, %{}, [])
  end

  @doc """
  Changeset that validates the required fields and calls the shorten
  function to create a short_url to the long_url.
  """

  def changeset(link, attrs) do
    changeset =
      link
      |> cast(attrs, [@required_fields])
      |> validate_required([@required_fields])

    changeset =
      case get_field(changeset, :long_url) do
        nil -> changeset
        long_url -> change(changeset, %{short_url: SlasherCode.shorten(long_url)})
      end

    changeset
    |> unique_constraint(:short_url)
    |> validate_url(:long_url)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn field, long_url ->
      case :http_uri.parse(String.to_charlist(long_url)) do
        {:ok, _} -> []
        {:error, _} -> [{field, "Sorry, this is not a valid Url."}]
      end
    end)
  end
end
