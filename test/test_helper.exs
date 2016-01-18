ExUnit.start()

defmodule ExFeedTestFileHelpers do

  def feed_formats() do
    [:rss, :rdf, :atom]
  end

  def read_file(format) when is_atom(format) do
    case format do
      :rss -> File.read!("test/data/rss.xml")
      :rdf -> File.read!("test/data/rdf.xml")
      :atom -> File.read!("test/data/atom.xml")
    end
  end

  def get_feed(format) when is_atom(format) do
    case format do
      :rss -> %ExFeed.Feed{
        title: "xkcd.com",
        link: "http://xkcd.com/",
        description: "xkcd.com: A webcomic of romance and math humor.",
        items: [
            %ExFeed.FeedItem{
              title: "Fixion",
              description: "some description",
              date: "Fri, 25 Dec 2015 05:00:00 -0000",
              link: "http://xkcd.com/1621/"
            },
            %ExFeed.FeedItem{
              title: "Christmas Settings",
              description: "some description",
              date: "Wed, 23 Dec 2015 05:00:00 -0000",
              link: "http://xkcd.com/1620/"
            }
          ]
        }
      :rdf -> %ExFeed.Feed{
        title: "The Oatmeal - Comics, Quizzes, Stories",
        link: "http://theoatmeal.com/",
        description: "The oatmeal tastes better than stale skittles found under the couch cushions",
        items: [
            %ExFeed.FeedItem{
            title: "Autocorrect hates you",
            description: "some description",
            date: "2015-12-15T20:02:00+01:00",
            link: "http://theoatmeal.com/comics/autocorrect"
            },
            %ExFeed.FeedItem{
              title: "Are you having a bad day?",
              description: "some description",
              date: "2015-12-09T19:49:49+01:00",
              link: "http://theoatmeal.com/blog/where_matt"
            }
          ]
        }
      :atom -> %ExFeed.Feed{
        title: "xkcd.com",
        link: "http://xkcd.com/",
        description: "",
        items: [
            %ExFeed.FeedItem{
            title: "Fixion",
            description: "description",
            date: "2015-12-25T00:00:00Z",
            link: "http://xkcd.com/1621/"
            },
            %ExFeed.FeedItem{
              title: "Christmas Settings",
              description: "description",
              date: "2015-12-23T00:00:00Z",
              link: "http://xkcd.com/1620/"
            }
          ]
        }
    end
  end

  def get_feed_index(format) when is_atom(format) do
    case format do
      :rss -> %ExFeedLoader.FeedIndex{id: "xkcd_rss",
        url: "http://xkcd.com/rss.xml",
        description: "A webcomic of romance and math humor."}
      :rdf -> %ExFeedLoader.FeedIndex{id: "the_oatmeal",
        url: "http://theoatmeal.com/feed/rss",
        description: "description"}
      :atom -> %ExFeedLoader.FeedIndex{id: "xkcd_atom",
        url: "http://xkcd.com/atom.xml",
        description: "A webcomic of romance and math humor."}
    end
  end

  def create_content_list() do
    for format <- feed_formats() do
      %ExFeedLoader.StoredContent{url: get_feed_index(format).url,
        timestamp: :erlang.system_time(:seconds),
        content: "#{format} test"}
    end
  end

end
