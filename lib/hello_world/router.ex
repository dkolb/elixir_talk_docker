defmodule HelloWorld.Router do
  require Logger
  use Plug.Router

  @greeting Application.get_env(:hello_world, :greeting)

  plug :match
  plug :dispatch

  get "/hello" do
    Logger.info("/hello GET request")
    send_resp(conn, 200, @greeting)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

end
