defmodule MetroServerPhoenix.Repo.Migrations.AddRoutesTable do
  use Ecto.Migration

  def change do
    create table(:routes, primary_key: false) do
      add :route_id,         :integer, null: false, primary_key: true
      add :agency_id,        :integer, null: false
      add :route_short_name, :string,  null: false
      add :route_long_name,  :string,  null: false
    end

    create index(:routes, :agency_id)
  end
end
