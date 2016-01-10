defmodule ExFeed.Server do
  use GenServer

  # public interface
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get_feed(url) do
    GenServer.call(__MODULE__, {:get_feed, url})
  end

  # message to handle, server state
  def handle_call({:get_feed, url}, _from, state) do
    {:reply, ExFeed.get_feed(url), state}
  end

end
