--liquibase formatted sql

--changeset RyanDerr:create-transaction-indexes

CREATE INDEX idx_transactions_from_to_account ON gophbank.transactions(from_account_id, to_account_id);
--rollback DROP INDEX idx_transactions_from_to_account ON gophbank.transactions;