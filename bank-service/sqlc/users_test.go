package db

import (
	"context"
	"database/sql"
	"testing"

	"github.com/RyanDerr/GophBank/util"
	"github.com/stretchr/testify/require"
)

func createRandomUser(t *testing.T) GophbankUsers {
	arg := CreateUserParams{
		FirstName: util.RandomName(),
		LastName:  util.RandomName(),
		Email:     util.RandomEmail(),
	}

	user, err := testQueries.CreateUser(context.Background(), arg)

	require.NoError(t, err)
	require.NotEmpty(t, user)

	require.Equal(t, arg.FirstName, user.FirstName)
	require.Equal(t, arg.LastName, user.LastName)
	require.Equal(t, arg.Email, user.Email)

	require.NotZero(t, user.UserID)

	return user
}

func TestCreateUser(t *testing.T) {
	createRandomUser(t)
}

func TestGetUser(t *testing.T) {
	user1 := createRandomUser(t)
	user2, err := testQueries.GetUser(context.Background(), user1.UserID)

	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, user1.FirstName, user2.FirstName)
	require.Equal(t, user1.LastName, user2.LastName)
	require.Equal(t, user1.Email, user2.Email)
}

func TestUpdateUserAll(t *testing.T) {
	user1 := createRandomUser(t)

	args := UpdateUserAllParams{
		UserID:    user1.UserID,
		FirstName: util.RandomName(),
		LastName:  user1.LastName,
		Email:     util.RandomEmail(),
	}

	user2, err := testQueries.UpdateUserAll(context.Background(), args)

	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, args.FirstName, user2.FirstName)
	require.Equal(t, user1.LastName, user2.LastName)
	require.Equal(t, args.Email, user2.Email)
}

func TestUpdateUserFirstName(t *testing.T) {
	user1 := createRandomUser(t)

	args := UpdateUserFirstNameParams{
		UserID:    user1.UserID,
		FirstName: util.RandomName(),
	}

	user2, err := testQueries.UpdateUserFirstName(context.Background(), args)

	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, args.FirstName, user2.FirstName)
	require.Equal(t, user1.LastName, user2.LastName)
	require.Equal(t, user1.Email, user2.Email)
}

func TestUpdateUserLastName(t *testing.T) {
	user1 := createRandomUser(t)

	args := UpdateUserLastNameParams{
		UserID:   user1.UserID,
		LastName: util.RandomName(),
	}

	user2, err := testQueries.UpdateUserLastName(context.Background(), args)

	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, user1.FirstName, user2.FirstName)
	require.Equal(t, args.LastName, user2.LastName)
	require.Equal(t, user1.Email, user2.Email)
}

func TestUpdateUserEmail(t *testing.T) {

	user1 := createRandomUser(t)

	args := UpdateUserEmailParams{
		UserID: user1.UserID,
		Email:  util.RandomEmail(),
	}

	user2, err := testQueries.UpdateUserEmail(context.Background(), args)

	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.UserID, user2.UserID)
	require.Equal(t, user1.FirstName, user2.FirstName)
	require.Equal(t, user1.LastName, user2.LastName)
	require.Equal(t, args.Email, user2.Email)
}

func TestDeleteUser(t *testing.T) {
	user1 := createRandomUser(t)

	err := testQueries.DeleteUser(context.Background(), user1.UserID)

	require.NoError(t, err)

	user2, err := testQueries.GetUser(context.Background(), user1.UserID)

	require.Error(t, err)
	require.EqualError(t, err, sql.ErrNoRows.Error())
	require.Empty(t, user2)
}

func TestListUsers(t *testing.T) {
	for i := 0; i < 10; i++ {
		createRandomUser(t)
	}

	arg := ListUsersParams{
		Limit:  5,
		Offset: 5,
	}

	users, err := testQueries.ListUsers(context.Background(), arg)

	require.NoError(t, err)
	require.Len(t, users, 5)

	for _, user := range users {
		require.NotEmpty(t, user)
	}
}
