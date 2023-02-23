defmodule MaychatWeb.Utils.Case do
  alias Recase.{CamelCase, SnakeCase}
  @converters [CamelCase, SnakeCase]

  @spec call(map(), module()) :: map()
  def call(body_params, converter)

  def call(body_params, converter) when converter in @converters do
    for {k, v} <- body_params, into: %{} do
      {
        converter.convert(k),
        v
      }
    end
  end

  # NOTE: actually, if PascalCase is passed, it is supported
  # Nevertheless, it's desired to be sure that the converters that we want
  # are passed.
  def call(_, conv), do: raise(ArgumentError, "converter #{inspect(conv)} is not supported")
end
