package db

import (
	"context"
	"testing"

	"github.com/RyanDerr/GophBank/util"
	"github.com/stretchr/testify/require"
)

func createRandomTransaction(t *testing.T, fromAccount, toAccount GophbankAccounts) GophbankTransactions {
	args := CreateTransactionParams{
		FromAccountID: fromAccount.AccountID,
		ToAccountID:   toAccount.AccountID,
		Amount:        util.RandomMoney(0, 10000),
	}
	transaction, err := testQueries.CreateTransaction(context.Background(), args)

	require.NoError(t, err)
	require.NotEmpty(t, transaction)

	require.Equal(t, args.FromAccountID, transaction.FromAccountID)
	require.Equal(t, args.ToAccountID, transaction.ToAccountID)
	require.Equal(t, args.Amount, transaction.Amount)

	require.NotZero(t, transaction.TransactionID)
	require.NotZero(t, transaction.TransactionTime)

	return transaction
}

func TestCreateTransaction(t *testing.T) {
	fromAccount := createRandomAccount(t)
	toAccount := createRandomAccount(t)
	createRandomTransaction(t, fromAccount, toAccount)
}

func TestGetTransaction(t *testing.T) {
	fromAccount := createRandomAccount(t)
	toAccount := createRandomAccount(t)
	createdTransaction := createRandomTransaction(t, fromAccount, toAccount)

	foundTransaction, err := testQueries.GetTransaction(context.Background(), createdTransaction.TransactionID)
	require.NoError(t, err)
	require.NotEmpty(t, foundTransaction)

	require.Equal(t, createdTransaction.FromAccountID, foundTransaction.FromAccountID)
	require.Equal(t, createdTransaction.ToAccountID, foundTransaction.ToAccountID)
	require.Equal(t, createdTransaction.Amount, foundTransaction.Amount)
	require.Equal(t, createdTransaction.TransactionID, foundTransaction.TransactionID)
	require.Equal(t, createdTransaction.TransactionTime, foundTransaction.TransactionTime)
}

func TestGetUserTransactions(t *testing.T) {
	account1 := createRandomAccount(t)
	account2 := createRandomAccount(t)
	for i := 0; i < 6; i ++ {
		createRandomTransaction(t, account1, account2)
		createRandomTransaction(t, account2, account1)
	}

	transactions, err := testQueries.ListUserTransactions(context.Background(), ListUserTransactionsParams{
		FromAccountID: account1.AccountID,
		ToAccountID:   account2.AccountID,
		Limit:         5,
		Offset:        1,
	})
	require.NoError(t, err)
	require.NotEmpty(t, transactions)

	require.Len(t, transactions, 5)

	for _, transaction := range transactions {
		require.NotEmpty(t, transaction)
		require.True(t, transaction.FromAccountID == account1.AccountID || transaction.ToAccountID == account1.AccountID)
		require.NotZero(t, transaction.TransactionID)
		require.NotZero(t, transaction.TransactionTime)
	}
}