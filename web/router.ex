defmodule MetroServerPhoenix.Router do
  use MetroServerPhoenix.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MetroServerPhoenix do
    pipe_through :api

    get "/stops/near-me", StopController, :near_me
    get "/stops/with-routes", StopController, :with_routes
  end
end
