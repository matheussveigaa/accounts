defmodule AccountsApi.Application.Mappers.AccountMapper do
  alias AccountsApi.Domain.Entities.Account

  def domain_to_dto(%Account{} = account) do
    account
    |> Map.drop([:events])
    |> Map.from_struct()
  end
end
