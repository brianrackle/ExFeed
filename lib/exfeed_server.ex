defmodule ExFeed.Server do
  use GenServer

  # public interface
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def get_feed(url) do
    GenServer.call(__MODULE__, {:get_feed, url})
  end

  def feed_type(xml) do
    GenServer.call(__MODULE__, {:feed_type, xml})
  end

  def parse_feed(format, xml) do
    GenServer.call(__MODULE__, {:parse_feed, format, xml})
  end

  # message to handle, server state
  def handle_call({:get_feed, url}, _from, state) do
    {:reply, ExFeed.get_feed(url), state}
  end

  def handle_call({:feed_type, xml}, _from, state) do
    {:reply, ExFeed.feed_type(xml), state}
  end

  def handle_Call({:parse_feed, format, xml}, _from, state) do
    {:reply, ExFeed.parse_feed(format, xml), state}
  end

end
