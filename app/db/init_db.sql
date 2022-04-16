DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS team CASCADE;
DROP TABLE IF EXISTS role CASCADE;
DROP TABLE IF EXISTS team_member CASCADE;
DROP TABLE IF EXISTS client CASCADE;
DROP TABLE IF EXISTS project CASCADE;
DROP TABLE IF EXISTS project_user CASCADE;
DROP TABLE IF EXISTS task CASCADE;
DROP TABLE IF EXISTS status CASCADE;
DROP TABLE IF EXISTS task_status CASCADE;

-- user, team and role

CREATE TABLE users (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(64) UNIQUE NOT NULL,
    hashed_password VARCHAR(64) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    first_name VARCHAR(64) NOT NULL,
    last_name VARCHAR(64) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_project_manager BOOLEAN DEFAULT FALSE,
    photo BYTEA
);

CREATE TABLE teams (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    team_name VARCHAR(64) UNIQUE NOT NULL,
    creator_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id)
);

CREATE TABLE roles (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    role_name VARCHAR(64) UNIQUE NOT NULL,
    creator_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id)
);

CREATE TABLE teams_users_roles (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    team_id INT NOT NULL,
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    creator_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
        REFERENCES users(id),
    CONSTRAINT fk_team
        FOREIGN KEY(team_id)
        REFERENCES teams(id),
    CONSTRAINT fk_role
        FOREIGN KEY(role_id)
        REFERENCES roles(id),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id),
    UNIQUE(team_id, user_id, role_id)
);

-- client, projects and tasks

CREATE TABLE clients (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    client_name VARCHAR(64) UNIQUE NOT NULL,
    creator_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id)
);

CREATE TABLE projects (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    project_name VARCHAR(128) UNIQUE NOT NULL,
    client_id INT NOT NULL,
    creator_id INT NOT NULL,
    planned_start_date TIMESTAMP,
    planned_end_date TIMESTAMP,
    actual_start_date TIMESTAMP,
    actual_end_date TIMESTAMP,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_client
        FOREIGN KEY(client_id)
        REFERENCES clients(id),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id)
);

CREATE TABLE projects_users (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    project_id INT NOT NULL,
    user_id INT NOT NULL,
    is_responsible BOOLEAN NOT NULL,
    creator_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_project
        FOREIGN KEY(project_id)
        REFERENCES projects(id),
    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
        REFERENCES users(id),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id),
    UNIQUE(project_id, user_id)
);

--

CREATE TABLE tasks (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    task_name VARCHAR(255) NOT NULL,
    project_id INT NOT NULL,
    creator_id INT NOT NULL,
    description TEXT,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_project
        FOREIGN KEY(project_id)
        REFERENCES projects(id),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id)
);

--

CREATE TABLE status (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    status_name VARCHAR(128) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE tasks_status (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    task_id INT NOT NULL,
    status_id INT NOT NULL,
    creator_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_task
        FOREIGN KEY(task_id)
        REFERENCES tasks(id),
    CONSTRAINT fk_status
        FOREIGN KEY(status_id)
        REFERENCES status(id),
    CONSTRAINT fk_creator
        FOREIGN KEY(creator_id)
        REFERENCES users(id)
);

--

DROP FUNCTION IF EXISTS update_updated_at_column();
DROP TRIGGER IF EXISTS update_user_modtime ON users;
DROP TRIGGER IF EXISTS update_team_modtime ON teams;
DROP TRIGGER IF EXISTS update_role_modtime ON roles;
DROP TRIGGER IF EXISTS update_team_member_modtime ON teams_users_roles;
DROP TRIGGER IF EXISTS update_client_modtime ON clients;
DROP TRIGGER IF EXISTS update_project_modtime ON projects;
DROP TRIGGER IF EXISTS update_project_user_modtime ON projects_users;
DROP TRIGGER IF EXISTS update_task_modtime ON tasks;
DROP TRIGGER IF EXISTS update_status_modtime ON status;
DROP TRIGGER IF EXISTS update_task_status_modtime ON tasks_status;

CREATE FUNCTION update_updated_at_column()
        RETURNS TRIGGER AS
    $$
    BEGIN
        NEW.updated_at = now();
        RETURN NEW;
    END;
    $$ language 'plpgsql';

CREATE TRIGGER update_user_modtime
            BEFORE UPDATE
            ON users
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_team_modtime
            BEFORE UPDATE
            ON teams
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_role_modtime
            BEFORE UPDATE
            ON roles
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_team_member_modtime
            BEFORE UPDATE
            ON teams_users_roles
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_client_modtime
            BEFORE UPDATE
            ON clients
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_project_modtime
            BEFORE UPDATE
            ON projects
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_project_user_modtime
            BEFORE UPDATE
            ON projects_users
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_task_modtime
            BEFORE UPDATE
            ON tasks
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_status_modtime
            BEFORE UPDATE
            ON status
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_task_status_modtime
            BEFORE UPDATE
            ON tasks_status
            FOR EACH ROW
        EXECUTE PROCEDURE update_updated_at_column();
