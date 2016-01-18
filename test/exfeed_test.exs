defmodule ExFeed.Test do
  use ExUnit.Case
  doctest ExFeed.Parser

  import ExFeed.Parser
  import ExFeed.Loader

  import ExFeedTestFileHelpers

  test "feed type identification" do
    feed_formats() |>
    Enum.map(&read_file/1) |>
    Enum.zip(feed_formats()) |>
    Enum.each(&(assert feed_type(elem(&1, 0)) == elem(&1, 1)))
  end

  test "parsing all formats" do
    feed_formats() |>
    Enum.map(&read_file/1) |>
    Enum.zip(feed_formats()) |>
    Enum.each(fn (x) ->
      assert match?(%ExFeed.Parser.Feed{}, parse_feed(elem(x, 0)))
    end)
  end

  test "parse all formats confirm result" do
    feed_formats() |>
    Enum.map(&read_file/1) |>
    Enum.zip(feed_formats()) |>
    Enum.each(fn (x) ->
      assert get_feed(elem(x,1)) == parse_feed(elem(x, 0))
    end)
  end

  test "store rss content" do
    assert Enum.count(create_content_list()) == Enum.count(feed_formats())
  end

  test "find rss content" do
    content_list = create_content_list()
    assertion = fn(format) ->
      assert find(content_list, get_feed_index(format).url) end

    feed_formats() |>
    Enum.each(assertion)
  end

  test "write rss map" do
    assert create_content_list() |> write("content_list.bin") == :ok
  end

  test "read rss map" do
    create_content_list() |> write("content_list.bin")
    read("content_list.bin") |>
    Enum.each(fn (content) ->
      assert match?(%ExFeed.Loader.StoredContent{}, content)
    end)
  end

  test "add feed prevent duplicates" do
    test_id = "xkcd_rss"
    test_url = "test"
    test_description = "description"

    result =
      feed_formats() |>
      Enum.map(&get_feed_index/1) |>
      add_feed(test_id, test_url, test_description) |>
      Enum.find(&(&1.id == test_id))

    assert result.url == get_feed_index(:rss).url
  end

  test "remove feed" do
    test_id = "xkcd_rss"

    result =
      feed_formats() |>
      Enum.map(&get_feed_index/1) |>
      remove_feed(test_id)

    assert Enum.count(result) == Enum.count(feed_formats()) - 1
  end

  test "get feed" do
    test_id = "xkcd_rss"

    result =
      feed_formats() |>
      Enum.map(&get_feed_index/1) |>
      get_feed(test_id)

    assert result.id == test_id
  end

end
