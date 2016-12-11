defmodule Frizzle.Calendar do
  use Frizzle.Web, :model

  schema "calendar" do
    field :service_id,   :string
    field :monday,       :boolean
    field :tuesday,      :boolean
    field :wednesday,    :boolean
    field :thursday,     :boolean
    field :friday,       :boolean
    field :saturday,     :boolean
    field :sunday,       :boolean
    field :start_date,   :string
    field :end_date,     :string
    field :service_name, :string
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct |>
      cast(params, [:service_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date, :service_name]) |>
      validate_required([:service_id, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :start_date, :end_date, :service_name])
  end

  def changeset_from_csv(row) do
    [ service_id,
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday,
      start_date,
      end_date,
      service_name ] = row

    changeset(
      %__MODULE__{},
      %{
        service_id: service_id,
        monday: monday,
        tuesday: tuesday,
        wednesday: wednesday,
        thursday: thursday,
        friday: friday,
        saturday: saturday,
        sunday: sunday,
        start_date: start_date,
        end_date: end_date,
        service_name: service_name
      }
    )
  end
end
