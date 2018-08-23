CREATE TABLE users (
    user_id     BIGINT        PRIMARY KEY,
    user_name   VARCHAR(50)   NOT NULL,
    pass        VARCHAR(50)   NOT NULL,
    email       VARCHAR(250)  NOT NULL,
    enabled     SMALLINT      DEFAULT 1
);

CREATE TABLE roles (
    role_id     BIGINT,
    role_name   VARCHAR(50)   NOT NULL,
    user_id     BIGINT,
    PRIMARY KEY (role_id, user_id)
);

