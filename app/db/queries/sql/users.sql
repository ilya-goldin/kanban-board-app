-- name: get-user-by-email^
SELECT id,
       username,
       email,
       created_at,
       updated_at,
       last_login,
       first_name,
       last_name,
       is_project_manager,
       photo
FROM users
WHERE email = :email
LIMIT 1;


-- name: get-user-by-username^
SELECT id,
       username,
       email,
       created_at,
       updated_at,
       last_login,
       first_name,
       last_name,
       is_project_manager,
       photo
FROM users
WHERE username = :username
LIMIT 1;


-- name: create-new-user<!
INSERT INTO users (username, email, first_name, last_name, is_project_manager, photo)
VALUES (:username, :email, :first_name, :last_name, :is_project_manager, :photo)
RETURNING
    id, created_at, updated_at;


-- name: update-user-by-username<!
UPDATE
    users
SET username           = :new_username,
    email              = :new_email,
    last_login         = :new_last_login,
    first_name         = :new_first_name
    last_name          = :new_last_name
    is_project_manager = :new_is_project_manager
    photo              = :new_photo
WHERE username = :username
RETURNING
    updated_at;