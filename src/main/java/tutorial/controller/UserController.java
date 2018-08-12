package tutorial.controller;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import tutorial.model.User;

@RestController
public class UserController {

    @RequestMapping("/users/{id}")
    @Cacheable("user")
    public User getUser (@PathVariable int id) {
        return null;
    }
}
