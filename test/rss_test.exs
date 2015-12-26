defmodule RssTest do
  use ExUnit.Case
  doctest Rss

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "parse with rss" do
    feed = RssFileHelpers.read_file(:rss)
    parsed_feed = Rss.parse(feed)
    assert match?({:ok, _}, parsed_feed)
  end

  test "parse with rdf" do
    feed = RssFileHelpers.read_file(:rdf)
    parsed_feed = Rss.parse(feed)
    assert match?({:ok, _}, parsed_feed)
  end

  test "parse with atom" do
    feed = RssFileHelpers.read_file(:atom)
    parsed_feed = Rss.parse(feed)
    assert match?({:ok, _}, parsed_feed)
  end
end
