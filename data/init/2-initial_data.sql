INSERT INTO users (user_id, user_name, pass, email, enabled)
VALUES
	(1, 'admin', '123456', 'admin@abc.com', 1),
	(2, 'user', '123456', 'user@abc.com', 1),
	(3, 'guest', '123456', 'guest@abc.com', 1)
ON CONFLICT (user_id) DO NOTHING
;
INSERT INTO roles (role_id, role_name, user_id)
VALUES
	(1, 'admin', 1),
	(2, 'user', 2),
	(3, 'guest', 3)
ON CONFLICT (role_id,user_id) DO NOTHING
