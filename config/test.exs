import Config

# In test we don't send emails.
config :accounts_api, AccountsApi.Mailer, adapter: Swoosh.Adapters.Test

config :accounts_api, :account_repository_impl, AccountsApi.Infrastructure.Persistence.Repository.AccountRepositoryImpl

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
