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

  def transfer(%Account{} = origin, %Account{} = destination, amount) do
    withdraw = %AccountEvent{type: AccountEvent.get_withdraw_type(), amount: amount, account_id: origin.id, is_transfer: true}
    deposit = %AccountEvent{type: AccountEvent.get_deposit_type(), amount: amount, account_id: destination.id, is_transfer: true}

    with {:ok, _event} <-  create_event(withdraw),
        {:ok, _event} <- create_event(deposit)
    do
      {:ok, [
        %Account{origin | balance: Account.get_balance(origin) - amount},
        %Account{destination | balance: Account.get_balance(destination) + amount}
      ]}
    else
      {:error, error} ->
        {:error, error}
    end
  end
end
