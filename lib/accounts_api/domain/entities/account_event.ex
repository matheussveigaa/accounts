defmodule AccountsApi.Domain.Entities.AccountEvent do
  use AccountsApi.Domain.Entities.BaseEntity

  typedstruct do
    field :id, String.t()
    field :account_id, String.t()
    field :created_at, DateTime.t()
    field :type, String.t()
    field :amount, float()
  end
end
