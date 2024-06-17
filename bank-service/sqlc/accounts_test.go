package db

import (
	"context"
	"testing"

	"github.com/RyanDerr/GophBank/util"
	"github.com/stretchr/testify/require"
)

func createRandomAccountType() AccountTypeEnum {
	choice := util.RandomInt(0, 1)
	if choice == 0 {
		return AccountTypeEnumSavings
	} else {
		return AccountTypeEnumChecking
	}
}

func createInterestRate(accountType AccountTypeEnum) float64 {
	if accountType == AccountTypeEnumSavings {
		return util.RandomInterestRate()
	} else {
		return 0
	}
}

func createRandomAccount(t *testing.T) GophbankAccounts {
	user := createRandomUser(t)
	accountType := createRandomAccountType()
	arg := CreateAccountParams{
		UserID:       user.UserID,
		AccountType:  accountType,
		Balance:      util.RandomMoney(0, 100000),
		InterestRate: createInterestRate(accountType),
	}
	account, err := testQueries.CreateAccount(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, account)

	require.Equal(t, arg.UserID, account.UserID)
	require.Equal(t, arg.AccountType, account.AccountType)
	require.Equal(t, arg.Balance, account.Balance)
	require.Equal(t, arg.InterestRate, account.InterestRate)

	require.NotZero(t, account.AccountID)
	require.NotZero(t, account.CreatedAt)

	return account
}

func TestCreateAccount(t *testing.T) {
	createRandomAccount(t)
}

func TestGetAccount(t *testing.T) {
	createdAccount := createRandomAccount(t)
	retrievedAccount, err := testQueries.GetAccount(context.Background(), createdAccount.AccountID)
	require.NoError(t, err)
	require.NotEmpty(t, retrievedAccount)

	require.Equal(t, createdAccount.UserID, retrievedAccount.UserID)
	require.Equal(t, createdAccount.AccountType, retrievedAccount.AccountType)
	require.Equal(t, createdAccount.Balance, retrievedAccount.Balance)
	require.Equal(t, createdAccount.InterestRate, retrievedAccount.InterestRate)
	require.Equal(t, createdAccount.CreatedAt, retrievedAccount.CreatedAt)
}

func TestDeleteAccount(t *testing.T) {
	createdAccount := createRandomAccount(t)
	err := testQueries.DeleteAccount(context.Background(), createdAccount.AccountID)
	require.NoError(t, err)

	_, err = testQueries.GetAccount(context.Background(), createdAccount.AccountID)
	require.Error(t, err)
}

func TestUpdateAccount(t *testing.T) {
	createdAccount := createRandomAccount(t)

	arg := UpdateAccountBalanceParams{
		AccountID: createdAccount.AccountID,
		Balance:   util.RandomMoney(0, 100000),
	}
	account, err := testQueries.UpdateAccountBalance(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, account)

	require.Equal(t, createdAccount.UserID, account.UserID)
	require.Equal(t, createdAccount.AccountType, account.AccountType)
	require.Equal(t, arg.Balance, account.Balance)
	require.Equal(t, createdAccount.InterestRate, account.InterestRate)
	require.Equal(t, createdAccount.CreatedAt, account.CreatedAt)
}

func TestListAccounts(t *testing.T) {
	var lastUserAccount GophbankAccounts
	for i := 0; i < 10; i++ {
		lastUserAccount = createRandomAccount(t)
	}

	arg := ListUserAccountsParams{
		UserID: lastUserAccount.UserID,
		Limit:  5,
		Offset: 0,
	}

	accounts, err := testQueries.ListUserAccounts(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, accounts)

	for _, account := range accounts {
		require.NotEmpty(t, account)
		require.Equal(t, lastUserAccount.UserID, account.UserID)
	}
}
