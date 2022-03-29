defmodule AccountsApi.Infrastructure.Persistence.Mappers.AccountMapper do
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}

  def schema_to_domain(fields) do
    %Account{
      id: elem(fields, 1),
      balance: elem(fields, 2)
    }
  end

  def schema_account_event_to_domain(fields) do
    %AccountEvent{
      id: elem(fields, 1),
      account_id: elem(fields, 2),
      type: elem(fields, 3),
      amount: elem(fields, 4),
      created_at: elem(fields, 5),
      is_transfer: elem(fields, 6)
    }
  end
end
