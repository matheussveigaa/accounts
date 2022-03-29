defmodule AccountsApi.Application.Services.AccountServiceTest do
  use ExUnit.Case

  alias AccountsApi.Application.Services.AccountService

  alias AccountsApi.Domain.UseCases.AccountUseCases
  alias AccountsApi.Domain.Entities.{Account, AccountEvent}

  setup_all do
    AccountUseCases.create(%Account{id: "d0f6c6ac-afef-44eb-ac0d-1a610ef3da6d"})
    AccountUseCases.create_event(%AccountEvent{
      amount: 100,
      type: "deposit",
      account_id: "d0f6c6ac-afef-44eb-ac0d-1a610ef3da6d"
    })

    AccountUseCases.create(%Account{id: "8b4ef7a0-eb4f-4e0a-9173-7591858719eb"})
    AccountUseCases.create_event(%AccountEvent{
      amount: 100,
      type: "deposit",
      account_id: "8b4ef7a0-eb4f-4e0a-9173-7591858719eb"
    })


    AccountUseCases.create(%Account{id: "b639d334-b1fa-4092-8bf8-63f7f7a15ddc"})
    AccountUseCases.create_event(%AccountEvent{
      amount: 20,
      type: "deposit",
      account_id: "b639d334-b1fa-4092-8bf8-63f7f7a15ddc"
    })

    AccountUseCases.create(%Account{id: "e68d6532-ced0-4682-b8c4-774562eb0c73"})
    AccountUseCases.create_event(%AccountEvent{
      amount: 20,
      type: "deposit",
      account_id: "e68d6532-ced0-4682-b8c4-774562eb0c73"
    })

    :ok
  end

  describe "AccountService.get_balance/1" do
    test "Should get balance from account with success" do
      # arrange
      account_id = "d0f6c6ac-afef-44eb-ac0d-1a610ef3da6d"

      # act
      {:ok, balance} = AccountService.get_balance(account_id)

      # assert
      assert not is_nil(balance)
      assert balance == 100
    end
  end

  describe "AccountService.handle_event/1" do
    test "Should deposit into destination account and create new one with success" do
      # arrange
      event = %{"type" => "deposit", "destination" => "100", "amount" => 10}

      # act
      {:ok, event_result} = AccountService.handle_event(event)

      # assert

      assert not is_nil(event_result)
      assert not is_nil(event_result["destination"])

      assert event_result["destination"].balance == 10
    end

    test "Should deposit into destination account with success" do
      # arrange
      event = %{"type" => "deposit", "destination" => "e68d6532-ced0-4682-b8c4-774562eb0c73", "amount" => 10}

      # act
      {:ok, event_result} = AccountService.handle_event(event)

      # assert

      assert not is_nil(event_result)
      assert not is_nil(event_result["destination"])

      assert event_result["destination"].balance == 30
    end

    test "Should transfer from origin to destination accounts with success" do
      # arrange
      event = %{"type" => "transfer", "origin" => "8b4ef7a0-eb4f-4e0a-9173-7591858719eb", "amount" => 15, "destination" => "300"}

      # act
      {:ok, event_result} = AccountService.handle_event(event)

      # assert

      assert not is_nil(event_result)
      assert not is_nil(event_result["origin"])
      assert not is_nil(event_result["destination"])

      assert event_result["origin"].balance == 85
      assert event_result["destination"].balance == 15
    end

    test "Should withdraw from origin account with success" do
      # arrange
      event = %{"type" => "withdraw", "origin" => "b639d334-b1fa-4092-8bf8-63f7f7a15ddc", "amount" => 5}

      # act
      {:ok, event_result} = AccountService.handle_event(event)

      # assert
      assert not is_nil(event_result)
      assert not is_nil(event_result["origin"])

      assert event_result["origin"].balance == 15
    end

    test "Should not withdraw from origin account when account not exists with success" do
      # arrange
      event = %{"type" => "withdraw", "origin" => "1234", "amount" => 5}

      # act & assert
      :not_found = AccountService.handle_event(event)
    end
  end
end
