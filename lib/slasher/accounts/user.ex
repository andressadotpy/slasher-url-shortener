defmodule Slasher.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Slasher.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string
    has_one :credential, Credential
    has_many :links, Slasher.Urls.Link

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast_assoc(:credential, with: &Credential.registration_changeset/2, required: true)
  end
end
