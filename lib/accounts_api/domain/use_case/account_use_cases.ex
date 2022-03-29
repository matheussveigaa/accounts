defmodule AccountsApi.Domain.UseCases.AccountUseCases do
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}
  alias AccountsApi.Domain.Repository.AccountRepository

  def create(%Account{} = account) do
    AccountRepository.create(account)
  end

  def update(%Account{} = account) do
    AccountRepository.update(account)
  end

  def create_event(%AccountEvent{} = event) do
    AccountRepository.create_event(event)
  end

  def find_by_id(id) do
    AccountRepository.find_by_id(id)
  end

  def deposit(account_id, amount) do
    with {:ok, destination_account} <- find_by_id(account_id),
         {:ok, _event_created} <- create_deposit_event(destination_account.id, amount) do
      destination_account = %Account{
        destination_account
        | balance: Account.get_balance(destination_account) + amount
      }

      {:ok, destination_account}
    else
      {:error, error} ->
        {:error, error}

      :not_found ->
        with {:ok, account_created} <- create(%Account{id: account_id, balance: amount}),
             {:ok, _event_created} <- create_deposit_event(account_created.id, amount) do
          {:ok, account_created}
        end
    end
  end

  def withdraw(account_id, amount) do
    with {:ok, origin_account} <- find_by_id(account_id),
         {:ok, _event_created} <- create_withdraw_event(origin_account.id, amount) do
      origin_account = %Account{
        origin_account
        | balance: Account.get_balance(origin_account) - amount
      }

      {:ok, origin_account}
    else
      {:error, error} ->
        {:error, error}

      :not_found ->
        :not_found
    end
  end

  def create_deposit_event(account_id, amount),
    do:
      create_event(%AccountEvent{
        type: AccountEvent.get_deposit_type(),
        account_id: account_id,
        amount: amount
      })

  def create_withdraw_event(account_id, amount),
    do:
      create_event(%AccountEvent{
        type: AccountEvent.get_withdraw_type(),
        account_id: account_id,
        amount: amount
      })

  def transfer(%Account{} = origin, destination_account_id, amount) do
    with {:ok, origin_account_updated} <- withdraw(origin.id, amount),
         {:ok, destination_account_updated} <- deposit(destination_account_id, amount) do
      {:ok, [origin_account_updated, destination_account_updated]}
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
