defmodule AccountsApi.Domain.Entities.AccountEvent do
  use AccountsApi.Domain.Entities.BaseEntity

  @deposit_type "deposit"
  @withdraw_type "withdraw"

  typedstruct do
    field(:id, String.t())
    field(:account_id, String.t())
    field(:is_transfer, boolean())
    field(:created_at, DateTime.t())
    field(:type, String.t())
    field(:amount, float())
  end

  def get_withdraw_type(), do: @withdraw_type
  def get_deposit_type(), do: @deposit_type
end
