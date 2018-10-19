defmodule CodeSnippets do
  def getKeys(prev,curr,keysList) do
    Enum.filter(keysList, fn(x) -> x > prev and x <= curr end)
  end
end
