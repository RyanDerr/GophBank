--liquibase formatted sql

--changeset RyanDerr:create-schema-and-tables
CREATE SCHEMA IF NOT EXISTS gophbank;

CREATE TABLE IF NOT EXISTS gophbank.users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) CHECK (first_name ~ '^[A-Za-z]+$') NOT NULL,
    last_name VARCHAR(50) CHECK (last_name ~ '^[A-Za-z]+$') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS gophbank.accounts (
    account_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES gophbank.users(user_id),
    account_type VARCHAR(10) CHECK (account_type IN ('checking', 'savings')) NOT NULL,
    balance DECIMAL(12, 2) CHECK (balance >= 0) NOT NULL,
    interest_rate DECIMAL(3, 2) CHECK ((account_type = 'savings' AND interest_rate >= 0) OR (account_type = 'checking' AND interest_rate = 0))
);

CREATE TABLE IF NOT EXISTS gophbank.transactions (
    transaction_id SERIAL PRIMARY KEY,
    from_account_id INTEGER REFERENCES gophbank.accounts(account_id),
    to_account_id INTEGER REFERENCES gophbank.accounts(account_id),
    amount DECIMAL(12, 2) NOT NULL,
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('withdraw', 'deposit', 'transfer')) NOT NULL,
    CHECK (
        (transaction_type = 'withdraw' AND from_account_id IS NOT NULL AND to_account_id IS NULL) OR
        (transaction_type = 'deposit' AND to_account_id IS NOT NULL AND from_account_id IS NULL) OR
        (transaction_type = 'transfer' AND from_account_id IS NOT NULL AND to_account_id IS NOT NULL)
    )
);

--rollback DROP TABLE IF EXISTS gophbank.transactions;
--rollback DROP TABLE IF EXISTS gophbank.accounts;
--rollback DROP TABLE IF EXISTS gophbank.users;
--rollback DROP SCHEMA IF EXISTS gophbank;