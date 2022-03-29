defmodule AccountsApi.Infrastructure.Persistence.MnesiaAdapter do
  alias :mnesia, as: Mnesia

  def start() do
    Mnesia.create_schema([node()])

    Mnesia.create_table(Accounts, attributes: [:id, :balance])

    Mnesia.create_table(AccountEvents,
      attributes: [:id, :account_id, :type, :amount, :created_at, :is_transfer]
    )

    Mnesia.start()
  end

  def clear_table(table) do
    Mnesia.clear_table(table)
  end
end
