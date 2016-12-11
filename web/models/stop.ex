defmodule MetroServerPhoenix.Stop do
  use MetroServerPhoenix.Web, :model
  import Ecto.Query

  @primary_key {:stop_id, :integer, []}
  schema "stops" do
    field :stop_name,   :string
    field :stop_desc,   :string
    field :location,    Geo.Point
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct |>
      cast(params, [:stop_id, :stop_name, :stop_desc, :location]) |>
      validate_required([:stop_id, :stop_name, :stop_desc, :location])
  end

  def changeset_from_csv(row) do
    [ stop_id, _ , stop_name, stop_desc, lat, lon | _ ] = row
    geo = %Geo.Point{coordinates: {lat, lon}, srid: 4326}
    changeset(
      %__MODULE__{},
      %{stop_id: stop_id,
        stop_name: stop_name,
        stop_desc: stop_desc,
        location: geo
      }
    )
  end

  def nearby!(repo, { lat, lon }) do
    %{rows: rows, num_rows: _} = Ecto.Adapters.SQL.query!(
      repo,
      "SELECT s.stop_id, s.stop_name, s.stop_desc,
         ST_Distance(
           ST_GeomFromText(
             CONCAT(
               'POINT(',
               CAST($1 AS VARCHAR),
               ' ',
               CAST($2 AS VARCHAR),
               ')'
             ),
             4326
           ),
           s.location
         ) AS dist
       FROM stops s
       ORDER BY dist ASC
       LIMIT 10",
      [lat, lon],
      []
    )

    Enum.map(rows, fn row ->
      [ stop_id, stop_name, stop_desc, stop_distance ] = row
      %{stop_id: stop_id,
        stop_name: stop_name,
        stop_desc: stop_desc
      }
    end)
  end

  def include_routes!(repo, stop_ids) do
    %{rows: rows, num_rows: _} = Ecto.Adapters.SQL.query!(
      repo,
      "SELECT st.stop_id, array_agg(DISTINCT r.route_short_name)
       FROM stop_times st
       INNER JOIN trips t ON t.trip_id = st.trip_id
       INNER JOIN routes r ON r.route_id = t.route_id
       WHERE st.stop_id IN (
         #{Enum.join(stop_ids, ",")}
       )
       GROUP BY st.stop_id",
      [],
      []
    )
    Enum.map(rows, fn row ->
      [ stop_id, route_short_names ] = row
      %{stop_id: stop_id,
        route_short_names: route_short_names
      }
    end)
  end

  # def include_routes!(repo, stop_ids) do
  #   repo.all(
  #     from stop_time in MetroServerPhoenix.StopTime,
  #     join: trip in assoc(stop_time, :trip),
  #     join: route in assoc(trip, :route),
  #     where: stop_time.stop_id in ^stop_ids,
  #     group_by: stop_time.stop_id,
  #     select: %{
  #       stop_id: stop_time.stop_id,
  #       route_short_names: fragment("array_agg(DISTINCT ?)", route.route_short_name)
  #     }
  #   )
  # end

end


