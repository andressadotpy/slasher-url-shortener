defmodule Slasher.Urls.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :date, :string
    field :long_url, :string
    field :short_url, :string

    belongs_to :user, Slasher.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:long_url, :short_url])
    |> validate_required([:long_url, :short_url])
  end
end
