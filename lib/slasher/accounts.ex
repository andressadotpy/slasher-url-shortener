defmodule Slasher.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query
  alias Slasher.Repo
  alias Slasher.Accounts.{Credential, User}

  def get_user(id) do
    Repo.get(User, id)
  end

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:credential)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.registration_changeset/2)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    cred_changeset =
      if attrs["credential"]["password"] == "" do
        &Credential.changeset/2
      else
        &Credential.registration_changeset/2
      end

    user
    |> User.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:credential, with: cred_changeset)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Slasher.Accounts.Credential

  @doc """
  Search for a user with the specified email and preload the credential
  association.
  """
  def get_user_by_email(email) do
    from(u in User, join: c in assoc(u, :credential), where: c.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  @doc """
  Calls get_user_by_email to find a user with the given email and
  checks if the password and email are a match.
  """
  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by_email(email)

    cond do
      # password matches email
      user && Comeonin.Pbkdf2.checkpw(given_pass, user.credential.password_hash) ->
        {:ok, user}

      # password doesn't match email
      user ->
        {:error, :unauthorized}

      # email doesn't exist
      true ->
        Comeonin.Pbkdf2.dummy_checkpw()
        {:error, :not_found}
    end
  end

  def list_credentials do
    Repo.all(Credential)
  end

  def get_credential!(id), do: Repo.get!(Credential, id)

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Credential.registration_changeset()
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end
end
