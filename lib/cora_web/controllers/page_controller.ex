defmodule CoraWeb.PageController do
  use CoraWeb, :controller

  def home(conn, _params) do
    conn
    |> assign(:page_title, "Home")
    |> render(:home)
  end
end
