defmodule ExFeed.Test do
  use ExUnit.Case
  doctest ExFeed

  import ExFeed
  import ExFeedTestFileHelpers

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
    feed = parse_feed(atom, xml)
    assert match?(%ExFeed.Feed{}, feed)
  end

  test "parse with rss result" do
    atom = :rss
    xml = read_file(atom)
    feed = parse_feed(atom, xml)
    model_feed = %ExFeed.Feed{
      title: "xkcd.com",
      link: "http://xkcd.com/",
      description: "xkcd.com: A webcomic of romance and math humor.",
      items: [
        %ExFeed.FeedItem{
          title: "Fixion",
          source: "http://xkcd.com/1621/",
          description: "some description",
          date: "Fri, 25 Dec 2015 05:00:00 -0000",
          link: "http://xkcd.com/1621/"
        },
        %ExFeed.FeedItem{
          title: "Christmas Settings",
          source: "http://xkcd.com/1620/",
          description: "some description",
          date: "Wed, 23 Dec 2015 05:00:00 -0000",
          link: "http://xkcd.com/1620/"
        }
      ]
    }
    assert model_feed == feed
  end

  test "parse with rdf" do
    atom = :rdf
    xml = read_file(atom)
    feed = parse_feed(atom, xml)
    assert match?(%ExFeed.Feed{}, feed)
  end

  test "parse with rdf result" do
    atom = :rdf
    xml = read_file(atom)
    feed = parse_feed(atom, xml)
    model_feed = %ExFeed.Feed{
      title: "The Oatmeal - Comics, Quizzes, Stories",
      link: "http://theoatmeal.com/",
      description: "The oatmeal tastes better than stale skittles found under the couch cushions",
      items: [
        %ExFeed.FeedItem{
        title: "Autocorrect hates you",
        source: "http://theoatmeal.com",
        description: "some description",
        date: "2015-12-15T20:02:00+01:00",
        link: "http://theoatmeal.com/comics/autocorrect"
        },
        %ExFeed.FeedItem{
          title: "Are you having a bad day?",
          source: "http://theoatmeal.com",
          description: "some description",
          date: "2015-12-09T19:49:49+01:00",
          link: "http://theoatmeal.com/blog/where_matt"
        }
      ]
    }
    assert model_feed == feed
  end

  test "store rss content" do
    assert Enum.count(create_content_map()) == Enum.count(feed_formats())
  end

  test "find rss content" do
    content_map = create_content_map()
    feed_formats() |> Enum.each(&(assert find(content_map, Atom.to_string(&1))))
  end

  # should use test setups to initialize test files
  test "write rss map" do
    assert create_content_map() |> write("content_map.bin") == :ok
  end

  test "read rss map" do
    for content <-  read("content_map.bin") |> Enum.unzip |> elem(1) do
      assert match?(%ExFeed.StoredContent{}, content)
    end
  end

  #atom identified with feed tag
  # test "parse with atom" do
  #   feed = RssFileHelpers.read_file(:atom)
  #   parsed_feed = Rss.parse(:atom, feed)
  #   assert match?({:ok, _}, parsed_feed)
  # end
end
