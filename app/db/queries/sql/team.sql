-- name: create_new_team<!
INSERT INTO team (team_name)
VALUES (:team_name)
RETURNING
    id, team_name, created_at, updated_at;

-- name: get_team_by_id^
SELECT id,
       team_name,
       created_at,
       updated_at
FROM team
WHERE id = :team_id
LIMIT 1;