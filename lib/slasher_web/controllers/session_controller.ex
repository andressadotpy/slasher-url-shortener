defmodule SlasherWeb.SessionController do
  use SlasherWeb, :controller

  alias SlasherWeb.Router.Helpers, as: Routes

  def new(conn, _) do
    render(conn, "new.html")
  end

  @doc """
  The create action get email and password from user's inputs and
  calls login_by_email_and_pass to verify if the email and password
  matches or if it's a wrong combination or if doesn't exists.
  """
  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case SlasherWeb.Auth.login_by_email_and_pass(conn, email, pass) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Password and email doesn't match :(")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> SlasherWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
