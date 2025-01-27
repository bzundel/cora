defmodule CoraWeb.Admin.AdminController do
  use CoraWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Administration")
    |> render(:index)
  end
end
