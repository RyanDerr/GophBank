-- name: CreateAccount :one
INSERT INTO gophbank.accounts (user_id, account_type, balance, interest_rate) VALUES ($1, $2, $3, $4) RETURNING *;

-- name: GetAccount :one
SELECT * FROM gophbank.accounts WHERE account_id = $1 LIMIT 1;

-- name: GetAccountForUpdate :one
SELECT * FROM gophbank.accounts WHERE account_id = $1 LIMIT 1 FOR NO KEY UPDATE;

-- name: ListAccounts :many
SELECT * FROM gophbank.accounts WHERE user_id = $1 ORDER BY account_id LIMIT $2 OFFSET $3;

-- name: UpdateAccount :one
UPDATE gophbank.accounts SET balance = $2 WHERE account_id = $1 RETURNING *;

-- name: AddAccountBalance :one
UPDATE gophbank.accounts SET balance = balance + sqlc.arg(amount) WHERE account_id = sqlc.arg(id) RETURNING *;

-- name: DeleteAccount :exec
DELETE FROM gophbank.accounts WHERE account_id = $1;