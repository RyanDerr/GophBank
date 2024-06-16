package db

import (
	"context"
	"database/sql"
	"testing"

	"github.com/RyanDerr/GophBank/util"
	"github.com/stretchr/testify/require"
)

func createRandomAccountType(t *testing.T) AccountTypeEnum {
	choice := util.RandomInt(0, 1)
	if choice == 0 {
		return AccountTypeEnumSavings
	} else {
		return AccountTypeEnumChecking
	}
}

func createInterestRate(accountType AccountTypeEnum) *float64 {
	if accountType == AccountTypeEnumSavings {
		interestRate := util.RandomInterestRate()
		return &interestRate
	} else {
		return nil
	}
}

func createRandomAccount(t *testing.T) GophbankAccounts {
	user := createRandomUser(t)
	accountType := createRandomAccountType(t)
	arg := CreateAccountParams{
		UserID: user.UserID,
		AccountType: accountType,
		Balance: util.RandomMoney(0, 100000),
		InterestRate: createInterestRate(accountType),
	}
}
