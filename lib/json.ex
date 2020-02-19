defmodule Atrium.JSON do
  @serializer Application.get_env(:atrium, :serializer, Jason)

  defdelegate decode(string), to: @serializer
  defdelegate decode!(string), to: @serializer
  defdelegate encode(string), to: @serializer
  defdelegate encode!(string), to: @serializer
end
