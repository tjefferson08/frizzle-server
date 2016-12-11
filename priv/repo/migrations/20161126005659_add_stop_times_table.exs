defmodule Frizzle.Repo.Migrations.AddStopTimesTable do
  use Ecto.Migration

  def change do
    create table(:stop_times) do
      add :trip_id,        :integer, null: false
      add :arrival_time,   :string,  null: false
      add :departure_time, :string,  null: false
      add :stop_id,        :integer, null: false
      add :stop_sequence,  :integer, null: false
    end

    create index(:stop_times, :trip_id)
    create index(:stop_times, :arrival_time)
    create index(:stop_times, :departure_time)
    create index(:stop_times, :stop_id)
  end
end
