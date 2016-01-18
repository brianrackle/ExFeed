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
      :rss -> %ExFeed.Parser.Feed{
        title: "xkcd.com",
        link: "http://xkcd.com/",
        description: "xkcd.com: A webcomic of romance and math humor.",
        items: [
            %ExFeed.Parser.FeedItem{
              title: "Fixion",
              description: "some description",
              date: "Fri, 25 Dec 2015 05:00:00 -0000",
              link: "http://xkcd.com/1621/"
            },
            %ExFeed.Parser.FeedItem{
              title: "Christmas Settings",
              description: "some description",
              date: "Wed, 23 Dec 2015 05:00:00 -0000",
              link: "http://xkcd.com/1620/"
            }
          ]
        }
      :rdf -> %ExFeed.Parser.Feed{
        title: "The Oatmeal - Comics, Quizzes, Stories",
        link: "http://theoatmeal.com/",
        description: "The oatmeal tastes better than stale skittles found under the couch cushions",
        items: [
            %ExFeed.Parser.FeedItem{
            title: "Autocorrect hates you",
            description: "some description",
            date: "2015-12-15T20:02:00+01:00",
            link: "http://theoatmeal.com/comics/autocorrect"
            },
            %ExFeed.Parser.FeedItem{
              title: "Are you having a bad day?",
              description: "some description",
              date: "2015-12-09T19:49:49+01:00",
              link: "http://theoatmeal.com/blog/where_matt"
            }
          ]
        }
      :atom -> %ExFeed.Parser.Feed{
        title: "xkcd.com",
        link: "http://xkcd.com/",
        description: "",
        items: [
            %ExFeed.Parser.FeedItem{
            title: "Fixion",
            description: "description",
            date: "2015-12-25T00:00:00Z",
            link: "http://xkcd.com/1621/"
            },
            %ExFeed.Parser.FeedItem{
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
      :rss -> %ExFeed.Loader.FeedIndex{id: "xkcd_rss",
        url: "http://xkcd.com/rss.xml",
        description: "A webcomic of romance and math humor."}
      :rdf -> %ExFeed.Loader.FeedIndex{id: "the_oatmeal",
        url: "http://theoatmeal.com/feed/rss",
        description: "description"}
      :atom -> %ExFeed.Loader.FeedIndex{id: "xkcd_atom",
        url: "http://xkcd.com/atom.xml",
        description: "A webcomic of romance and math humor."}
    end
  end

  def create_content_list() do
    for format <- feed_formats() do
      %ExFeed.Loader.StoredContent{url: get_feed_index(format).url,
        timestamp: :erlang.system_time(:seconds),
        content: "#{format} test"}
    end
  end

end
