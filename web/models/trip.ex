defmodule Frizzle.Trip do
  use Frizzle.Web, :model

  @primary_key {:trip_id, :integer, []}
  schema "trips" do
    field :service_id,    :string
    field :trip_headsign, :string

    belongs_to :route, Frizzle.Route
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:route_id, :service_id, :trip_id, :trip_headsign])
    |> validate_required([:route_id, :service_id, :trip_id, :trip_headsign])
  end

  def changeset_from_csv(row) do
    [route_id, service_id, trip_id, trip_headsign | _] = row
    changeset(
      %__MODULE__{},
      %{route_id: route_id,
        service_id: service_id,
        trip_id: trip_id,
        trip_headsign: trip_headsign}
    )
  end
end
