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

  def get_feed_index(format) do
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

  def content_list() do
    for format <- feed_formats(), do: "#{format} test" # read_file(format)
  end

  def create_content_map() do
    reducer = fn(x, acc) ->
      ExFeedLoader.store(acc, Atom.to_string(elem(x, 0)), elem(x, 1) ) end

    Enum.zip(feed_formats(), content_list()) |>
    Enum.reduce(%{}, reducer)
  end

end
