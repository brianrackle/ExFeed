defmodule ExFeed do
  import SweetXml

  defmodule FeedItem do
    defstruct title: nil, source: nil, link: nil, description: nil, date: nil
  end

  defmodule Feed do
    defstruct title: nil, link: nil, description: nil, items: []
  end

  def parse(format, xml) do
    case format do
      :rss -> xml |> parse_rss |> to_feed
      :rdf -> xml |> parse_rdf |> to_feed
      :atom -> xml |> parse_atom |> to_feed
      _ -> {:error, nil}
    end
  end

  def feed_type(xml) do
    cond do
      path?(xml, ~x"//rss"o) -> :rss
      path?(xml, ~x"//rdf:RDF"o) -> :rdf
      path?(xml, ~x"//atom"o) -> :atom
      true -> nil
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
    {:ok, %{struct(Feed, feed) | items: items}}
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
  def parse_rdf(xml) do
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
  def parse_atom(xml) do
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
      description: ~x"./content/text()"s,
      date: ~x"./published/text()"s
      ]
    )
  end

end
