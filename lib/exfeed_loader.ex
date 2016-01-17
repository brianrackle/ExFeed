defmodule ExFeedLoader do

  defmodule StoredContent do
    defstruct timestamp: {0,0,0}, content: nil
  end

  defmodule FeedIndex do
    defstruct id: nil, url: nil, description: nil
  end

  def add_feed(list, id, url, description) do
    case Enum.find(list, &(&1.id == id)) do
      nil -> [%FeedIndex{id: id, url: url, description: description} | list]
      %FeedIndex{} -> list
    end
  end

  def remove_feed(list, id) do
    Enum.filter(list, &(&1.id != id))
  end

  def get_feed(list, id) do
    Enum.find(list, &(&1.id == id))
  end

  # app start -> sets the cache folder -> ExFeed.read cache folder -> app exit -> ExFeed.write
  # stores url as key and datetime + content as body
  def store(map, url, content) do
    # This belongs at a different level
    # stored = Map.get(map, url, %StoredContent{})
    # if stored.timestamp -
    #   result when (:erlang.system_time(:seconds) - result.timestamp) > 60 * 60
    # end
    Map.put_new(map, url, %StoredContent{timestamp: :erlang.system_time(:seconds), content: content})
  end

  # eventually want the ability to append to FeedItems as well.
  # returns date and content
  def find(map, url) do
    Map.get(map, url, %StoredContent{})
  end

  def read(path) when is_binary(path) do
    with {:ok, body} <- File.read(path), do: :erlang.binary_to_term(body)
  end

  def write(map, path) when is_map(map) and is_binary(path) do
    File.write(path, :erlang.term_to_binary(map))
  end
end
