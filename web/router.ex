defmodule Frizzle.Router do
  use Frizzle.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Frizzle do
    pipe_through :api

    get "/stops/near-me", StopController, :near_me
    get "/stops/with-routes", StopController, :with_routes
  end
end
