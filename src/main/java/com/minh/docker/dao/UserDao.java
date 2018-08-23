package com.minh.docker.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.minh.docker.model.User;


@Repository
public class UserDao {
    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public UserDao (JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Cacheable("user")
    public User getUser (long id) {
        String sql = "Select user_id,user_name,email From users where user_id=?";
        return jdbcTemplate.queryForObject(
            sql,
            new BeanPropertyRowMapper<>(User.class),
            id
        );
    }
}
