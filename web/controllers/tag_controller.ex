defmodule Survey.TagController do
  use Survey.Web, :controller
  require Logger
  plug :action

  def index(conn, params) do
    Logger.info(inspect(params, pretty: true))
    render conn, "index.html"
  end

  def submit(conn, params) do
    Logger.info(inspect(params, pretty: true))
    text conn, inspect(params, pretty: true)
  end
end
