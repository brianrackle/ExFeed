defmodule ExFeed.Loader do
  import HTTPoison, only: [get: 1]

  defmodule StoredContent do
    defstruct url: nil, timestamp: 0, content: nil
  end

  # feedindex is iterated through by daemon once every 30 minutes to get updated StoredContent
  defmodule FeedIndex do
    defstruct id: nil, url: nil, description: nil
  end

  # {:ok, feed} = ExFeed.get_feed("http://xkcd.com/rss.xml")
  # feed.title
  # for item <- feed.items, do: IO.puts("Title: #{item.title}\nDescription: #{item.description}\nPublication:#{item.date}\n------\n\n")
  def get_doc(url) when is_binary(url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- get(url), do: body
  end

  def add_feed(index_list, id, url, description) do
    case Enum.find(index_list, &(&1.id == id)) do
      nil -> [%FeedIndex{id: id, url: url, description: description} | index_list]
      %FeedIndex{} -> index_list
    end
  end

  def remove_feed(index_list, id) do
    Enum.filter(index_list, &(&1.id != id))
  end

  def get_feed(index_list, id) do
    Enum.find(index_list, &(&1.id == id))
  end

  # app start -> sets the cache folder -> ExFeed.read cache folder -> app exit -> ExFeed.write
  # stores url as key and datetime + content as body
  # if stored.timestamp -
  #   result when (:erlang.system_time(:seconds) - result.timestamp) > 60 * 60
  # end
  def store(content_list, url, content) do
    case Enum.find(content_list, &(&1.url == url)) do
      nil -> [%StoredContent{url: url, timestamp: :erlang.system_time(:seconds), content: content} | content_list]
      %StoredContent{} -> content_list
    end
  end

  def find(content_list, url) do
    Enum.find(content_list, &(&1.url == url))
  end

  def read(path) when is_binary(path) do
    with {:ok, body} <- File.read(path), do: :erlang.binary_to_term(body)
  end

  def write(content_list, path) when is_binary(path) do
    File.write(path, :erlang.term_to_binary(content_list))
  end
end
