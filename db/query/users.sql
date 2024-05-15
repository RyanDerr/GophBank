-- name: CreateUser :one
INSERT INTO gophbank.users (first_name, last_name, email) VALUES ($1, $2, $3) RETURNING *;

-- name: GetUser :one
SELECT * FROM gophbank.users WHERE user_id = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM gophbank.users ORDER BY user_id LIMIT $1 OFFSET $2;

-- name: UpdateUserAll :one
UPDATE gophbank.users SET first_name = $1, last_name = $2, email = $3 WHERE user_id = $4 RETURNING *;

-- name: UpdateUserFirstName :one
UPDATE gophbank.users SET first_name = $1 WHERE user_id = $2 RETURNING *;

-- name: UpdateUserLastName :one
UPDATE gophbank.users SET last_name = $1 WHERE user_id = $2 RETURNING *;

-- name: UpdateUserEmail :one
UPDATE gophbank.users SET email = $1 WHERE user_id = $2 RETURNING *;

-- name: DeleteUser :exec
DELETE FROM gophbank.users WHERE user_id = $1;