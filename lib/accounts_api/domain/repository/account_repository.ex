defmodule AccountsApi.Domain.Repository.AccountRepository do
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}

  @callback create(account :: Account.t()) :: {:ok, Account.t()} | {:error, any()}
  @callback update(account :: Account.t()) :: {:ok, Account.t()} | {:error, any()}
  @callback find_by_id(id :: String.t()) :: {:ok, Account.t()} | :not_found | {:error, any()}

  @callback create_event(event :: AccountEvent.t()) :: {:ok, AccountEvent.t()} | {:error, any()}

  def create(%Account{} = account) do
    impl().create(account)
  end

  def update(%Account{} = account) do
    impl().update(account)
  end

  def create_event(%AccountEvent{} = event) do
    impl().create_event(event)
  end

  def find_by_id(id) do
    impl().find_by_id(id)
  end

  defp impl() do
    Application.get_env(:accounts_api, :account_repository_impl)
  end
end
