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
    xml = read_file(atom)
    feed = parse(atom, xml)
    assert match?({:ok, %ExFeed.Feed{}}, feed)
  end

  test "parse with rss result" do
    atom = :rss
    xml = read_file(atom)
    feed = parse(atom, xml)
    model_feed = %ExFeed.Feed{
      title: "xkcd.com",
      link: "http://xkcd.com/",
      description: "xkcd.com: A webcomic of romance and math humor.",
      items: [
        %ExFeed.FeedItem{
        title: "Fixion",
        home: "http://xkcd.com/1621/",
        description: "some description",
        date: "Fri, 25 Dec 2015 05:00:00 -0000",
        link: "http://xkcd.com/1621/"
        },
        %ExFeed.FeedItem{
          title: "Christmas Settings",
          home: "http://xkcd.com/1620/",
          description: "some description",
          date: "Wed, 23 Dec 2015 05:00:00 -0000",
          link: "http://xkcd.com/1620/"
        }
      ]
}
      assert {:ok, model_feed} == feed
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
