defmodule AccountsApi.Domain.Entities.Account do
  use AccountsApi.Domain.Entities.BaseEntity

  typedstruct do
    field :id, String.t()
    field :balance, String.t()
    field :events, [AccountsApi.Domain.Entities.AccountEvent.t()]
  end
end
