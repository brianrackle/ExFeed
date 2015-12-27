defmodule ExFeed do
  # if <?xml version="1.0" encoding="UTF-8"?>
  # <rss version="2.0"
  #see buzzfeed.xml and xkcd.xml

  # if <rdf:RDF
  # see oatmeal.xml


  # doc |> xpath(~x"//game/matchups/matchup"l) |> Enum.map fn(node) -> %{ matchup: node |> xpath(~x"./name/text()")} end
  import SweetXml

  defmodule Feed do
    defstruct title: nil, link: nil, description: nil
  end
#guid is link in rss, link is source
  defmodule FeedItem do
    defstruct title: nil, link: nil, source: nil, description: nil, date: nil
  end

  def parse(format, xml) do
    case format do
      :rss -> parse_rss(xml)
      :rdf -> parse_rdf(xml)
      :atom -> parse_atom(xml)
      _ -> {:error, nil}
    end
  end

  def feed_type(xml) do
    cond do
      path?(xml, ~x"//rss") -> :rss
      path?(xml, ~x"//rdf:RDF") -> :rdf
      path?(xml, ~x"//atom") -> :atom
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

  defp parse_rss(xml) do
    {:ok, struct(Stream, parse_rss_stream(xml))}
  end

  defp parse_rss_stream(xml) do
    # parse title defstruct title: nil, link: nil, description: nil
    xml |>
    xpath(
    ~x"//rss/channel",
    title: ~x"./title/text()",
    link: ~x"./link/text()",
    desciption: ~x"./description/text()")
  end

  #returns {:ok, feed} on success
  def parse_rdf(_xml) do

  end

  #returns {:ok, feed} on success
  def parse_atom(_xml) do

  end


end
