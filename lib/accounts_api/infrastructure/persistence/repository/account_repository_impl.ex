defmodule AccountsApi.Infrastructure.Persistence.Repository.AccountRepositoryImpl do
  alias :mnesia, as: Mnesia
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}

  @behaviour AccountsApi.Domain.Repository.AccountRepository

  def create(%Account{} = account) do
    account = %Account{account | id: UUID.uuid4()}

    :ok = Mnesia.dirty_write({Accounts, account.id, account.balance})

    {:ok, account}
  rescue
  error ->
    {:error, error}
  end

  def update(%Account{} = account) do
    Mnesia.transaction(fn ->
      :ok = Mnesia.write({Accounts, account.id, account.balance})
    end)
  end

  def create_event(%AccountEvent{} = event) do
    event = %AccountEvent{event | id: UUID.uuid4(), created_at: DateTime.utc_now()}

    :ok = Mnesia.dirty_write({AccountEvents, event.id, event.account_id, event.type, event.amount, event.created_at, event.is_transfer})

    {:ok, event}
  end
end
