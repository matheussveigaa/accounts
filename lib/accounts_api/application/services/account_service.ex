defmodule AccountsApi.Application.Services.AccountService do
  alias AccountsApi.Domain.UseCases.AccountUseCases
  alias AccountsApi.Domain.Entities.Account

  alias AccountsApi.Application.Mappers.AccountMapper

  def handle_event(%{"type" => "deposit", "destination" => destination, "amount" => amount}) do
    case AccountUseCases.deposit(destination, amount) do
      {:ok, destination_account} ->
        {:ok,
         %{
           "destination" => AccountMapper.domain_to_dto(destination_account)
         }}

      {:error, error} ->
        {:error, error}
    end
  end

  def handle_event(%{"type" => "withdraw", "origin" => origin, "amount" => amount}) do
    case AccountUseCases.withdraw(origin, amount) do
      {:ok, origin_account} ->
        {:ok, %{"origin" => AccountMapper.domain_to_dto(origin_account)}}

      {:error, error} ->
        {:error, error}

      :not_found ->
        :not_found
    end
  end

  def handle_event(%{
        "type" => "transfer",
        "origin" => origin,
        "amount" => amount,
        "destination" => destination
      }) do
    case AccountUseCases.find_by_id(origin) do
      {:ok, origin_account} ->
        case AccountUseCases.transfer(origin_account, destination, amount) do
          {:ok, [origin_account_updated, destination_account_updated]} ->
            {:ok,
             %{
               "origin" => AccountMapper.domain_to_dto(origin_account_updated),
               "destination" => AccountMapper.domain_to_dto(destination_account_updated)
             }}

          {:error, error} ->
            {:error, error}
        end

      {:error, error} ->
        {:error, error}

      :not_found ->
        :not_found
    end
  end

  def get_balance(account_id) do
    case AccountUseCases.find_by_id(account_id) do
      {:ok, account} ->
        {:ok, Account.get_balance(account)}

      :not_found ->
        :not_found
    end
  end
end
