defmodule AccountsApi.Infrastructure.Persistence.Repository.AccountRepositoryImpl do
  alias :mnesia, as: Mnesia
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}
  alias AccountsApi.Infrastructure.Persistence.Mappers.AccountMapper

  @behaviour AccountsApi.Domain.Repository.AccountRepository

  def create(%Account{} = account) do
    account = %Account{account | id: account.id || UUID.uuid4()}

    :ok = Mnesia.dirty_write({Accounts, account.id, account.balance})

    {:ok, account}
  rescue
    error ->
      {:error, error}
  end

  def create_event(%AccountEvent{} = event) do
    event = %AccountEvent{event | id: UUID.uuid4(), created_at: DateTime.utc_now()}

    :ok =
      Mnesia.dirty_write(
        {AccountEvents, event.id, event.account_id, event.type, event.amount, event.created_at,
         event.is_transfer}
      )

    {:ok, event}
  end

  def find_by_id(id) do
    with [account_schema | _tail] <- Mnesia.dirty_match_object({Accounts, id, :_}),
         account_events_schema <-
           Mnesia.dirty_match_object({AccountEvents, :_, id, :_, :_, :_, :_}) do
      account_events =
        if(not Enum.empty?(account_events_schema),
          do: Enum.map(account_events_schema, &AccountMapper.schema_account_event_to_domain/1),
          else: []
        )

      {:ok, %Account{AccountMapper.schema_to_domain(account_schema) | events: account_events}}
    else
      [] ->
        :not_found
    end
  end
end
