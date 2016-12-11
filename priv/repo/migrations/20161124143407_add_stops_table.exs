defmodule MetroServerPhoenix.Repo.Migrations.AddStopsTable do
  use Ecto.Migration

  def up do
     create table(:stops, primary_key: false) do
      add :stop_id,   :integer, null: false, primary_key: true
      add :stop_name, :string,  null: false
      add :stop_desc, :string,  null: false
    end
     execute("SELECT AddGeometryColumn ('stops','location',4326,'POINT',2);")
     create index(:stops, :location, using: :gist)
  end

  def down do
    drop table(:stops)
  end
end
