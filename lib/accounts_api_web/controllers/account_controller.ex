defmodule AccountsApiWeb.AccountController do
  use AccountsApiWeb, :controller

  @moduledoc """
  controller for rest api
  """

  alias AccountsApi.Application.Services.AccountService

  def handle_event(conn, params) do
    case AccountService.handle_event(params) do
      {:ok, event_result} ->
        conn
        |> put_status(201)
        |> json(event_result)

      {:error, error} ->
        conn
        |> put_status(400)
        |> json(error)

      :not_found ->
        conn
        |> put_status(404)
        |> text("0")
    end
  end

  def get_balance(conn, %{"account_id" => account_id} = _params) do
    case AccountService.get_balance(account_id) do
      {:ok, balance} ->
        conn
        |> put_status(200)
        |> text(balance)

      :not_found ->
        conn
        |> put_status(404)
        |> text("0")
    end
  end

  def reset(conn, _params) do
    :mnesia.clear_table(Accounts)
    :mnesia.clear_table(AccountEvents)

    conn
    |> put_status(200)
    |> text("OK")
  end
end
