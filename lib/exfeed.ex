defmodule ExFeed do
  import SweetXml, only: [xpath: 2, xpath: 3, sigil_x: 2]
  import HTTPoison, only: [get: 1]

  defmodule FeedItem do
    defstruct title: nil, source: nil, link: nil, description: nil, date: nil
  end

  defmodule Feed do
    defstruct title: nil, link: nil, description: nil, items: []
  end

  defmodule StoredContent do
    defstruct timestamp: {0,0,0}, content: nil
  end

  # eventually want the ability to append to FeedItems as well.
  # returns date and content
  def find(map, url) do
    Map.get(map, url)
  end

  # stores url as key and datetime + content as body
  def store(map, url, content) do
    Map.put_new(map, url, %StoredContent{timestamp: :erlang.timestamp, content: content})
  end

  # usage:
  # {:ok, feed} = ExFeed.get_feed("http://xkcd.com/rss.xml")
  # feed.title
  # for item <- feed.items, do: IO.puts("Title: #{item.title}\nDescription: #{item.description}\nPublication:#{item.date}\n------\n\n")
  def read(path) when is_binary(path) do
    with {:ok, body} <- File.read(path), do: :erlang.binary_to_term(body)
  end

  def write(path, map) when is_binary(path) and is_map(map) do
    File.write(path, :erlang.term_to_binary(map))
  end

  def get_doc(url) when is_binary(url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <- get(url),
     do: body
  end

  def parse_feed(doc) when is_binary(doc) do
    doc |> feed_type |> parse_feed(doc)
  end

  def parse_feed(format, doc) when is_atom(format) and is_binary(doc) do
    case format do
      :rss -> doc |> parse_rss |> to_feed
      :rdf -> doc |> parse_rdf |> to_feed
      :atom -> doc |> parse_atom |> to_feed
    end
  end

  def feed_type(doc) when is_binary(doc) do
    cond do
      path?(doc, ~x"//rss"o) -> :rss
      path?(doc, ~x"//rdf:RDF"o) -> :rdf
      path?(doc, ~x"//feed"o) -> :atom
    end
  end

  defp path?(xml, path) do
    try do
      nil != xpath(xml, path)
    rescue
      _ -> false
    end
  end

  defp to_feed(feed) do
    items = for item <- feed.items, do: struct(FeedItem, item)
    %{struct(Feed, feed) | items: items}
  end

  defp parse_rss(xml) do
    xml |>
    xpath(
    ~x"//rss/channel",
    title: ~x"./title/text()"s,
    link: ~x"./link/text()"s,
    description: ~x"./description/text()"s,
    items: [
      ~x"./item"l,
      title: ~x"./title/text()"s,
      source: ~x"./link/text()"s,
      link: ~x"./guid/text()"s,
      description: ~x"./description/text()"s,
      date: ~x"./pubDate/text()"s
      ]
    )
  end

  #returns {:ok, feed} on success
  defp parse_rdf(xml) do
    xml |>
    xpath(
    ~x"//rdf:RDF",
    title: ~x"./channel/title/text()"s,
    link: ~x"./channel/link/text()"s,
    description: ~x"./channel/description/text()"s,
    items: [
      ~x"./item"l,
      title: ~x"./title/text()"s,
      source: ~x"./dc:source/text()"s,
      link: ~x"./link/text()"s,
      description: ~x"./description/text()"s,
      date: ~x"./dc:date/text()"s
      ]
    )
  end

  #returns {:ok, feed} on success
  defp parse_atom(xml) do
    xml |>
    xpath(
    ~x"//feed",
    title: ~x"./title/text()"s,
    link: ~x"./id/text()"s,
    description: ~x"./subtitle/text()"s,
    items: [
      ~x"./entry"l,
      title: ~x"./title/text()"s,
      # source: ~x"./dc:source/text()"s,
      link: ~x"./id/text()"s,
      description: ~x"./summary/text()"s,
      date: ~x"./updated/text()"s
      ]
    )
  end

end
