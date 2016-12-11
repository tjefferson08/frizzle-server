# Script for loading the database with local GFTS data. Run it as:
#
#     mix run priv/repo/seeds.exs
#
defmodule Frizzle.LoadGtfs do
  alias Frizzle.Repo

  @insert_batch_size 1000

  @model_map [
    %{model: Module.concat(Frizzle, "Stop"),
      filename: "google_transit/stops.txt"},
    %{model: Module.concat(Frizzle, "Route"),
      filename: "google_transit/routes.txt"},
    %{model: Module.concat(Frizzle, "StopTime"),
      filename: "google_transit/stop_times.txt"},
    %{model: Module.concat(Frizzle, "Trip"),
      filename: "google_transit/trips.txt"},
    %{model: Module.concat(Frizzle, "Calendar"),
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

Frizzle.LoadGtfs.clear
Frizzle.LoadGtfs.load_all

