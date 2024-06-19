// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.26.0
// source: transactions.sql

package db

import (
	"context"
)

const createTransaction = `-- name: CreateTransaction :one
INSERT INTO gophbank.transactions (from_account_id, to_account_id, amount) VALUES ($1, $2, $3) RETURNING transaction_id, from_account_id, to_account_id, amount, transaction_time
`

type CreateTransactionParams struct {
	FromAccountID int32   `json:"from_account_id"`
	ToAccountID   int32   `json:"to_account_id"`
	Amount        float64 `json:"amount"`
}

func (q *Queries) CreateTransaction(ctx context.Context, arg CreateTransactionParams) (GophbankTransactions, error) {
	row := q.db.QueryRowContext(ctx, createTransaction, arg.FromAccountID, arg.ToAccountID, arg.Amount)
	var i GophbankTransactions
	err := row.Scan(
		&i.TransactionID,
		&i.FromAccountID,
		&i.ToAccountID,
		&i.Amount,
		&i.TransactionTime,
	)
	return i, err
}

const getTransaction = `-- name: GetTransaction :one
SELECT transaction_id, from_account_id, to_account_id, amount, transaction_time FROM gophbank.transactions WHERE transaction_id = $1 LIMIT 1
`

func (q *Queries) GetTransaction(ctx context.Context, transactionID int32) (GophbankTransactions, error) {
	row := q.db.QueryRowContext(ctx, getTransaction, transactionID)
	var i GophbankTransactions
	err := row.Scan(
		&i.TransactionID,
		&i.FromAccountID,
		&i.ToAccountID,
		&i.Amount,
		&i.TransactionTime,
	)
	return i, err
}

const listUserTransactions = `-- name: ListUserTransactions :many
SELECT transaction_id, from_account_id, to_account_id, amount, transaction_time FROM gophbank.transactions WHERE from_account_id = $1 OR to_account_id = $2 ORDER BY transaction_id LIMIT $3 OFFSET $4
`

type ListUserTransactionsParams struct {
	FromAccountID int32 `json:"from_account_id"`
	ToAccountID   int32 `json:"to_account_id"`
	Limit         int32 `json:"limit"`
	Offset        int32 `json:"offset"`
}

func (q *Queries) ListUserTransactions(ctx context.Context, arg ListUserTransactionsParams) ([]GophbankTransactions, error) {
	rows, err := q.db.QueryContext(ctx, listUserTransactions,
		arg.FromAccountID,
		arg.ToAccountID,
		arg.Limit,
		arg.Offset,
	)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var items []GophbankTransactions
	for rows.Next() {
		var i GophbankTransactions
		if err := rows.Scan(
			&i.TransactionID,
			&i.FromAccountID,
			&i.ToAccountID,
			&i.Amount,
			&i.TransactionTime,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
