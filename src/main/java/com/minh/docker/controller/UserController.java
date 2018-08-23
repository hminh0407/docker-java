package com.minh.docker.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.minh.docker.model.User;
import com.minh.docker.service.UserService;

@RestController
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController (UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/users/{id}")
    public User getUser (@PathVariable long id) {
        return this.userService.getUser(id);
    }
}
