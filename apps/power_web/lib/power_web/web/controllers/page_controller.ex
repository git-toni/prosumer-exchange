defmodule PowerWeb.Web.PageController do
  use PowerWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
