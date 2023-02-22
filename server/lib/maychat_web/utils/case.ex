defmodule MaychatWeb.Utils.Case do
  alias Recase.{CamelCase, SnakeCase}
  @converters [CamelCase, SnakeCase]

  def convert(body_params, converter) when converter in @converters do
    for {k, v} <- body_params, into: %{} do
      {
        converter.convert(k),
        v
      }
    end
  end
end
