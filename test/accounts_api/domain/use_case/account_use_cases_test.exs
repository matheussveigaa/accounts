defmodule AccountsApi.Domain.UseCases.AccountUseCasesTest do
  use ExUnit.Case

  alias AccountsApi.Domain.Entities.{Account, AccountEvent}
  alias AccountsApi.Domain.UseCases.AccountUseCases

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

  describe "AccountUseCases.transfer/3" do
    test "Should transfer amount from origin to destination with success" do
      # arrange
      origin = %Account{
        id: UUID.uuid4(),
        events: build_events()
      }

      destination = %Account{
        id: UUID.uuid4()
      }

      # act
      {:ok, accounts} = AccountUseCases.transfer(origin, destination, 20.23)

      [balance_origin, balance_destination] = accounts

      # assert
      assert not is_nil(balance_origin)
      assert not is_nil(balance_destination)

      assert balance_origin.balance == 42.989999999999995
      assert balance_destination.balance == 20.23
    end
  end
end
