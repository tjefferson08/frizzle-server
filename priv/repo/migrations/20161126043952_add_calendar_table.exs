defmodule MetroServerPhoenix.Repo.Migrations.AddCalendarTable do
  use Ecto.Migration

  def change do
    create table(:calendar) do
      add :service_id,   :string,  null: false
      add :monday,       :boolean, null: false, default: false
      add :tuesday,      :boolean, null: false, default: false
      add :wednesday,    :boolean, null: false, default: false
      add :thursday,     :boolean, null: false, default: false
      add :friday,       :boolean, null: false, default: false
      add :saturday,     :boolean, null: false, default: false
      add :sunday,       :boolean, null: false, default: false
      add :start_date,   :string,  null: false
      add :end_date,     :string,  null: false
      add :service_name, :string,  null: false
    end
  end
end
