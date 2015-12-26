defmodule Rss do
  # if <?xml version="1.0" encoding="UTF-8"?>
  # <rss version="2.0"
  #see buzzfeed.xml and xkcd.xml

  # if <rdf:RDF
  # see oatmeal.xml


  # doc |> xpath(~x"//game/matchups/matchup"l) |> Enum.map fn(node) -> %{ matchup: node |> xpath(~x"./name/text()")} end
  import SweetXml

#guid is link in rss, link is source
  defmodule FeedItem do
    defstruct title: nil, link: nil, source: nil, description: nil, date: nil
  end

  def parse(xml) do
    cond do
      {:ok, feed} = parse_rss(xml) -> {:ok, feed}
      {:ok, feed} = parse_rdf(xml) -> {:ok, feed}
      {:ok, feed} = parse_atom(xml) -> {:ok, feed}
      true -> {:error, nil}
    end
  end

  #returns {:ok, feed} on success
  def parse_rss(xml) do
    case path(xml, ~x"//rss") do
      {:ok, body} -> {:ok, body}
      {:error, body} -> {:error, body}
    end
  end

  #returns {:ok, feed} on success
  def parse_rdf(xml) do
    case path(xml, ~x"//rdf:RDF") do
      {:ok, body} -> {:ok, body}
      {:error, body} -> {:error, body}
    end
  end

  #returns {:ok, feed} on success
  def parse_atom(xml) do

  end

  #returns {ok, children} on success
  defp path(doc, path) do
    try do
      {:ok, xpath(doc, path)}
    rescue
      _ -> {:error, nil}
    end
  end

end
