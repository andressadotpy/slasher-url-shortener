defmodule SlasherWeb.UserView do
  use SlasherWeb, :view

  alias Slasher.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
