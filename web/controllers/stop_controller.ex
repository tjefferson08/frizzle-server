defmodule Frizzle.StopController do
  use Frizzle.Web, :controller
  alias Frizzle.Stop
  import Ecto.Changeset

  def index(conn, _params) do
    render conn, "index.html"
  end

  def near_me(conn, params = %{ "lat" => lat, "lon" => lon }) do

    types = %{lat: :float, lon: :float}
    changeset = cast({%{}, types}, params, [:lat, :lon])
    |> validate_required([:lat, :lon])
    if (changeset.valid?) do
      conn
      |> put_resp_header("access-control-allow-origin", "*")
      |> json(%{
        status: :ok,
        data: Stop.nearby!(Repo, { lat, lon })
      })
    else
      IO.inspect changeset.errors
      conn
      |> put_status(:bad_request)
      |> json(%{ status: :error })
    end
  end

  def with_routes(conn, %{ "stop-ids" => stop_ids }) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> json(%{
      status: :ok,
      data: Stop.include_routes!(Repo, String.split(stop_ids, ","))
    })
  end
end
