-- name: CreateTransaction :one
INSERT INTO gophbank.transactions (from_account_id, to_account_id, amount, transaction_type) VALUES ($1, $2, $3, $4) RETURNING *;

-- name: GetTransaction :one
SELECT * FROM gophbank.transactions WHERE transaction_id = $1 LIMIT 1;

-- name: ListUserTransactions :many
SELECT * FROM gophbank.transactions WHERE from_account_id = $1 OR to_account_id = $2 ORDER BY transaction_id LIMIT $3 OFFSET $4;