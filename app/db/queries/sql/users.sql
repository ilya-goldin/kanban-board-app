-- name: get-user-by-email^
SELECT id,
       username,
       email,
       hashed_password,
       salt,
       created_at,
       updated_at,
       first_name,
       last_name,
       is_active,
       is_project_manager,
       photo
FROM users
WHERE email = :email
LIMIT 1;


-- name: get-user-by-username^
SELECT id,
       username,
       email,
       hashed_password,
       salt,
       created_at,
       updated_at,
       first_name,
       last_name,
       is_active,
       is_project_manager,
       photo
FROM users
WHERE username = :username
LIMIT 1;


-- name: create-new-user<!
INSERT INTO users (username, email, hashed_password, salt, first_name, last_name, photo)
VALUES (:username, :email, :hashed_password, :salt, :first_name, :last_name, :photo)
RETURNING
    id, username, email, first_name, last_name, is_active, is_project_manager, photo, created_at, updated_at;


-- name: update-user-by-username<!
UPDATE
    users
SET username           = :new_username,
    email              = :new_email,
    hashed_password    = :hashed_password,
    salt               = :salt,
    first_name         = :new_first_name,
    last_name          = :new_last_name,
    photo              = :photo
WHERE username = :username
RETURNING
    username, email, first_name, last_name, is_active, is_project_manager, photo, created_at, updated_at;