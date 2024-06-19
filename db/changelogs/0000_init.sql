--liquibase formatted sql

--changeset RyanDerr:create-schema-tables-and-iam

CREATE SCHEMA IF NOT EXISTS gophbank;

CREATE USER db_domain_users WITH LOGIN;
GRANT rds_iam TO db_domain_users;

CREATE TABLE IF NOT EXISTS gophbank.users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) CHECK (first_name ~ '^[A-Za-z]+$') NOT NULL,
    last_name VARCHAR(50) CHECK (last_name ~ '^[A-Za-z]+$') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TYPE account_type_enum AS ENUM ('checking', 'savings');

CREATE TABLE IF NOT EXISTS gophbank.accounts (
    account_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES gophbank.users(user_id) NOT NULL,
    account_type account_type_enum NOT NULL,
    balance NUMERIC(12, 2) CHECK (balance >= 0) NOT NULL,
    interest_rate NUMERIC(3, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT interest_rate_check CHECK ((account_type != 'checking') OR (interest_rate = 0))
);

CREATE TABLE IF NOT EXISTS gophbank.transactions (
    transaction_id SERIAL PRIMARY KEY,
    from_account_id INTEGER REFERENCES gophbank.accounts(account_id) NOT NULL,
    to_account_id INTEGER REFERENCES gophbank.accounts(account_id) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--rollback DROP TABLE IF EXISTS gophbank.transactions;
--rollback DROP TABLE IF EXISTS gophbank.accounts;
--rollback DROP TYPE IF EXISTS account_type_enum;
--rollback DROP TABLE IF EXISTS gophbank.users;
--rollback DROP USER IF EXISTS db_domain_users;
--rollback DROP SCHEMA IF EXISTS gophbank;