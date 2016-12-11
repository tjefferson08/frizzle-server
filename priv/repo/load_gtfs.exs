# Script for loading the database with local GFTS data. Run it as:
#
#     mix run priv/repo/seeds.exs
#
defmodule MetroServerPhoenix.LoadGtfs do
  alias MetroServerPhoenix.Repo

  @insert_batch_size 1000

  @model_map [
    %{model: Module.concat(MetroServerPhoenix, "Stop"),
      filename: "google_transit/stops.txt"},
    %{model: Module.concat(MetroServerPhoenix, "Route"),
      filename: "google_transit/routes.txt"},
    %{model: Module.concat(MetroServerPhoenix, "StopTime"),
      filename: "google_transit/stop_times.txt"},
    %{model: Module.concat(MetroServerPhoenix, "Trip"),
      filename: "google_transit/trips.txt"},
    %{model: Module.concat(MetroServerPhoenix, "Calendar"),
      filename: "google_transit/calendar.txt"}
  ]

  def models do
    @model_map
    |> Enum.map(&( &1[:model] ))
  end

  def clear do
    models
    |> Enum.map(&Repo.delete_all/1)
  end

  def load(model, file) do
    File.stream!(file)
    |> CSV.decode
    |> Enum.drop(1)
    |> Enum.map(fn row ->
      changeset = model.changeset_from_csv(row)
      if (changeset.valid?) do
        changeset.changes
      else
        IO.inspect changeset.errors
        raise "Unable to load changeset from CSV"
      end
    end)
    |> Enum.chunk(@insert_batch_size, @insert_batch_size, [])
    |> Enum.map(fn rows -> Repo.insert_all(model, rows) end)
  end

  def load_all do
    Enum.each(
      @model_map,
      fn config -> load(config.model, config.filename) end
    )
  end
end

MetroServerPhoenix.LoadGtfs.clear
MetroServerPhoenix.LoadGtfs.load_all

