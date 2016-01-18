defmodule ExFeed.Server do
  use GenServer

  # keep a map of last updated
  # serialize on terminate :erlang.term_to_binary
  # deserialize on init :erlange.binary_to_term
  # init with data store location. If no file then create file with
  # File.write( file_name, :erlang.term_to_binary(%{}))
  # File.read!( file_name ) |> :erlang.binary_to_term

  # public interface
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  # def init([]) do
  #   schedule_refresh_content()
  #   {:ok, []}
  # end

  def get_doc(url) do
    GenServer.call(__MODULE__, {:get_doc, url})
  end

  def parse_feed(doc) do
    GenServer.call(__MODULE__, {:parse_feed, doc})
  end

  def parse_feed(format, doc) do
    GenServer.call(__MODULE__, {:parse_feed, format, doc})
  end

  def feed_type(doc) do
    GenServer.call(__MODULE__, {:feed_type, doc})
  end

  def refresh_content(state) do
    # Do your work here and return state
    IO.puts("Refreshing content")
    state
  end

  defp schedule_refresh_content() do
    Process.send_after(self(), :refresh_content, 60_000 * 60) #process every hour
  end

  # GenServer interface
  def handle_info(:refresh_content, state) do
    state = refresh_content(state)
    schedule_refresh_content()
    {:noreply, state}
  end

  def handle_call({:get_doc, url}, _from, state) do
    {:reply, ExFeed.Loader.get_doc(url), state}
  end

  def handle_call({:parse_feed, doc}, _from, state) do
    {:reply, ExFeed.Parser.parse_feed(doc), state}
  end

  def handle_call({:parse_feed, format, doc}, _from, state) do
    {:reply, ExFeed.Parser.parse_feed(format, doc), state}
  end

  def handle_call({:feed_type, doc}, _from, state) do
    {:reply, ExFeed.Parser.feed_type(doc), state}
  end

end
