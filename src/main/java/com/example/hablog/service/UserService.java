package com.example.hablog.service;

import com.example.hablog.entity.User;

public interface UserService {
    User register(String username, String password, String email);
    String login(String username, String password);
    User getUserById(Long id);
}