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

  setup do
    AccountUseCases.create(%Account{id: "d99e5658-04a9-4d3d-a6b8-402850d1be7b"})

    :ok
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

  describe "AccountUseCases.find_by_id/1" do
    test "Should find account by id with success" do
      # arrange
      id = "d99e5658-04a9-4d3d-a6b8-402850d1be7b"

      # act
      {:ok, account} = AccountUseCases.find_by_id(id)

      # assert
      assert not is_nil(account)
      assert account.id == id
    end

    test "Should not find account by id when not exists with success" do
      # arrange
      id = "25703678-31ad-425e-9e62-afcf09459193"

      # act & assert
      :not_found = AccountUseCases.find_by_id(id)
    end
  end
end
