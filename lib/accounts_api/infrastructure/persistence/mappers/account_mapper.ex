defmodule AccountsApi.Infrastructure.Persistence.Mappers.AccountMapper do

  alias AccountsApi.Domain.Entities.Account

  def schema_to_domain(fields) do
    %Account{
      id: elem(fields, 1),
      balance: elem(fields, 2)
    }
  end
end
