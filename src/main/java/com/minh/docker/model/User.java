package com.minh.docker.model;

import java.io.Serializable;

public class User implements Serializable {
    private long   userId;
    private String userName;
    private String email;

    public long getUserId () {
        return userId;
    }

    public void setUserId (long userId) {
        this.userId = userId;
    }

    public String getUserName () {
        return userName;
    }

    public void setUserName (String userName) {
        this.userName = userName;
    }

    public String getEmail () {
        return email;
    }

    public void setEmail (String email) {
        this.email = email;
    }
}
