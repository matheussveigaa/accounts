defmodule AccountsApi.Application.Mappers.AccountMapperTest do
  use ExUnit.Case

  alias AccountsApi.Application.Mappers.AccountMapper
  alias AccountsApi.Domain.Entities.Account

  describe "AccountMapper.domain_to_dto/1" do
    test "Should map from domain account to dto with success" do
      # arrange
      account = %Account{id: "100", balance: 20.2}

      # act
      dto = AccountMapper.domain_to_dto(account)

      # assert
      assert not is_nil(dto)

      assert dto.balance == account.balance
      assert dto.id == account.id
    end
  end
end
