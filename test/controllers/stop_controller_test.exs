defmodule MetroServerPhoenix.StopControllerTest do
  use MetroServerPhoenix.ConnCase

  test "GET /api/stops/near-me"
  test "GET /api/stops/with-routes"

  test "GET /api/stops/near-me with params", %{conn: conn} do
    conn = get conn, "/api/stops/near-me"
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
