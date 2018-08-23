package com.minh.docker.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.minh.docker.dao.UserDao;
import com.minh.docker.model.User;

@Service
public class UserService {
    private final UserDao userDao;

    @Autowired
    public UserService (UserDao userDao) {
        this.userDao = userDao;
    }

    public User getUser (long id) {
        return this.userDao.getUser(id);
    }
}
