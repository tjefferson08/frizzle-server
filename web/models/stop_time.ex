defmodule Frizzle.StopTime do
  use Frizzle.Web, :model

  schema "stop_times" do
    field :arrival_time,   :string
    field :departure_time, :string
    field :stop_sequence,  :integer

    belongs_to :stop, Frizzle.Stop
    belongs_to :trip, Frizzle.Trip
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    # sanitize_times = fn time ->
    #   time = String.trim(time)

    #   { hour_of_day, _ } = Integer.parse(String.slice(time, 0..1))

    #   # TODO: figure out a better way to deal with midnight <> time of
    #   # day conflict
    #   (if (hour_of_day >= 24) do
    #     (hour_of_day
    #     |> rem(24)
    #     |> Integer.to_string) <> String.slice(time, 2..-1)
    #   else
    #     time
    #   end)
    #   |> String.pad_leading(8, "0")

    # end

    # params = Enum.map(params, fn
    #   { :arrival_time, val } -> { :arrival_time, sanitize_times.(val) }
    #   { :departure_time, val } -> { :departure_time, sanitize_times.(val) }
    #   pair -> pair
    # end)
    # |> Enum.into(%{})

    struct
    |> cast(params, [:trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence])
    |> validate_required([:trip_id, :arrival_time, :departure_time, :stop_id, :stop_sequence])
  end

  def changeset_from_csv(row) do
    [trip_id, arrival_time, departure_time, stop_id, stop_sequence | _] = row
    changeset(
      %__MODULE__{},
      %{trip_id: trip_id,
        arrival_time: arrival_time,
        departure_time: departure_time,
        stop_id: stop_id,
        stop_sequence: stop_sequence}
    )
  end
end
