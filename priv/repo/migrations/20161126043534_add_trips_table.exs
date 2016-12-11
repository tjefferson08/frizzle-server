defmodule Frizzle.Repo.Migrations.AddTripsTable do
  use Ecto.Migration

  def change do
    create table(:trips, primary_key: false) do
      add :trip_id,       :integer, null: false, primary_key: true
      add :route_id,      :integer, null: false
      add :service_id,    :string,  null: false
      add :trip_headsign, :string,  null: false
    end

    create index(:trips, :route_id)
    create index(:trips, :service_id)
  end
end
