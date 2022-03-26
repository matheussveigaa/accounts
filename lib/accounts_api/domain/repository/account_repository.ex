defmodule AccountsApi.Domain.Repository.Repository do

  # @callback get_by_repo_and_username(repo :: String.t(), username :: String.t()) :: {:ok, Repository.t()} | {:error, map()} | :not_found
  # @callback get_issues(repo :: String.t(), username :: String.t()) :: {:ok, [Issue.t()]} | {:error, map()}
  # @callback get_contributors(repo :: String.t(), username :: String.t()) :: {:ok, [Contributor.t()]} | {:error, map()}

  # def get_by_repo_and_username(repo, username) do
  #   impl().get_by_repo_and_username(repo, username)
  # end

  # def get_issues(repo, username) do
  #   impl().get_issues(repo, username)
  # end

  # def get_contributors(repo, username) do
  #   impl().get_contributors(repo, username)
  # end

  defp impl() do
    Application.get_env(:accounts_api, :account_repository_impl)
  end
end
