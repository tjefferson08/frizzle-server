defmodule MetroServerPhoenix.Route do
  use MetroServerPhoenix.Web, :model

  @primary_key {:route_id, :integer, []}
  schema "routes" do
    field :agency_id,          :integer
    field :route_long_name,    :string
    field :route_short_name,   :string
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct |>
      cast(params, [:route_id, :agency_id, :route_short_name, :route_long_name]) |>
      validate_required([:route_id, :agency_id, :route_short_name, :route_long_name])
  end

  def changeset_from_csv(row) do
    [route_id, agency_id, route_short_name, route_long_name | _] = row
    changeset(
      %__MODULE__{},
      %{route_id: route_id,
        agency_id: agency_id,
        route_short_name: route_short_name,
        route_long_name: route_long_name}
    )
  end
end
