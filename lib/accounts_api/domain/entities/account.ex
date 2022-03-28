defmodule AccountsApi.Domain.Entities.Account do
  use AccountsApi.Domain.Entities.BaseEntity

  alias AccountsApi.Domain.Entities.AccountEvent

  @deposit_type AccountEvent.get_deposit_type()
  @withdraw_type AccountEvent.get_withdraw_type()

  typedstruct do
    field :id, String.t()
    field :balance, float()
    field :events, [AccountEvent.t()]
  end

  def get_balance(%__MODULE__{events: events} = _account) when is_nil(events), do: 0.0

  def get_balance(%__MODULE__{} = account) do
    account.events
    |> Enum.reduce(0.0, fn event, acc ->
      case event.type do
        @deposit_type ->
          acc + event.amount

        @withdraw_type ->
          acc - event.amount

        _ ->
          acc
      end
    end)
  end
end
