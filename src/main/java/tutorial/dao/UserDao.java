package tutorial.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import tutorial.model.User;

@Repository
public class UserDao {
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public UserDao (JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public User getUser (int id) {
        String sql = "Select id,name,age From user where id=?";
        return jdbcTemplate.queryForObject(
            sql,
            new BeanPropertyRowMapper<>(User.class)
        );
    }
}
