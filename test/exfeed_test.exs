defmodule ExFeedTest do
  use ExUnit.Case
  doctest ExFeed

import ExFeed
  import ExFeedTestFileHelpers

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "feed type rss" do
    atom = :rss
    feed = read_file(atom)
    assert atom == feed_type(feed)
  end

  test "feed type rdf" do
    atom = :rdf
    feed = read_file(atom)
    assert atom == feed_type(feed)
  end

  test "parse with rss" do
    atom = :rss
    feed = read_file(atom)
    assert match?({:ok, %Stream{}}, parse(atom, feed))
  end

  # test "parse with rdf" do
  #   feed = RssFileHelpers.read_file(:rdf)
  #   parsed_feed = Rss.parse(:rdf, feed)
  #   assert match?({:ok, _}, parsed_feed)
  # end
  #
  # test "parse with atom" do
  #   feed = RssFileHelpers.read_file(:atom)
  #   parsed_feed = Rss.parse(:atom, feed)
  #   assert match?({:ok, _}, parsed_feed)
  # end
end
