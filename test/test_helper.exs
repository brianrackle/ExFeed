ExUnit.start()

defmodule RssFileHelpers do

  def read_file(atom) do
    case atom do
      :rss -> File.read!("test/data/rss.xml")
      :rdf -> File.read!("test/data/rdf.xml")
      :atom -> nil
      _ -> nil
    end
  end
end
