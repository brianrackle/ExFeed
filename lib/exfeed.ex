defmodule ExFeed do
  import SweetXml, only: [xpath: 2, xpath: 3, sigil_x: 2]
  import HTTPoison, only: [get: 1]

  defmodule FeedItem do
    defstruct title: nil, source: nil, link: nil, description: nil, date: nil
  end

  defmodule Feed do
    defstruct title: nil, link: nil, description: nil, items: []
  end

  # usage:
  # {:ok, feed} = ExFeed.get_feed("http://xkcd.com/rss.xml")
  # feed.title
  # for item <- feed.items, do: IO.puts("Title: #{item.title}\nDescription: #{item.description}\nPublication:#{item.date}\n------\n\n")

  def get_doc(url) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
    end
  end

  def parse_feed(doc) do
    doc |> feed_type |> parse_feed(doc)
  end

  def parse_feed(format, doc) do
    case format do
      :rss -> doc |> parse_rss |> to_feed
      :rdf -> doc |> parse_rdf |> to_feed
      :atom -> doc |> parse_atom |> to_feed
      _ -> nil
    end
  end

  def feed_type(doc) do
    cond do
      path?(doc, ~x"//rss"o) -> :rss
      path?(doc, ~x"//rdf:RDF"o) -> :rdf
      path?(doc, ~x"//feed"o) -> :atom
      true -> :undefined
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
