defmodule AccountsApi.Domain.Entities.BaseEntity do
  defmacro __using__(_) do
    quote do
      use TypedStruct
      use ExConstructor
    end
  end
end
