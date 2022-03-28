defmodule AccountsApi.Application.Services.AccountService do
  alias AccountsApi.Domain.UseCases.AccountUseCases
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}

  def handle_event(%{"type" => "deposit", "destination" => destination, "amount" => amount}) do

    with {:ok, destination_account} <- AccountUseCases.find_by_id(destination),
        {:ok, _event_created} <- create_deposit_event(destination_account.id, amount)
    do
      destination_account = %Account{destination_account | balance: Account.get_balance(destination_account)}

      {:ok, %{destination: Map.drop(destination_account, [:events])}}

    else
      {:error, error} ->
        {:error, error}

      :not_found ->
        with {:ok, account_created} <- AccountUseCases.create(%Account{id: destination, balance: amount}),
          {:ok, _event_created} <- create_deposit_event(account_created.id, amount)
        do
          {:ok, %{destination: Map.drop(account_created, [:events])}}
        end
    end
  end

  def handle_event(%{"type" => "withdraw", "origin" => origin, "amount" => amount}) do

  end

  def handle_event(%{"type" => "transfer", "origin" => origin, "amount" => amount, "destination" => destination}) do

  end

  def create_deposit_event(account_id, amount), do: AccountUseCases.create_event(%AccountEvent{type: AccountEvent.get_deposit_type(), account_id: account_id, amount: amount})
end
