defmodule MetroServerPhoenix.PageController do
  use MetroServerPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
