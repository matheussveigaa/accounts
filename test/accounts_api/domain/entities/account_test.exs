defmodule AccountsApi.Domain.Entities.AccountTest do
  use ExUnit.Case

  alias AccountsApi.Domain.Entities.{Account, AccountEvent}

  def build_events() do
    [
      %AccountEvent{
        amount: 10.23,
        type: "withdraw"
      },
      %AccountEvent{
        amount: 23.45,
        type: "deposit"
      },
      %AccountEvent{
        amount: 50,
        type: "withdraw"
      },
      %AccountEvent{
        amount: 100,
        type: "deposit"
      }
    ]
  end

  describe "Account.get_balance" do
    test "Should get actual balance with success" do
      # arrange
      account = %Account{
        events: build_events()
      }

      # act
      balance = Account.get_balance(account)

      # assert
      assert balance > 0
      assert balance == 63.22
    end

    test "Should get actual balance when new account with success" do
      # arrange
      account = %Account{}

      # act
      balance = Account.get_balance(account)

      # assert
      assert balance == 0
    end
  end
end
