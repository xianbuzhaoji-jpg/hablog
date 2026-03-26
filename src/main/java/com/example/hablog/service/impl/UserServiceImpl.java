package com.example.hablog.service.impl;

import com.example.hablog.entity.User;
import com.example.hablog.mapper.UserMapper;
import com.example.hablog.service.UserService;
import com.example.hablog.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserMapper userMapper;

    @Override
    public User register(String username, String password, String email) {
        User existUser = userMapper.selectByUsername(username);
        if (existUser != null) {
            throw new RuntimeException("Username already exists");
        }
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        userMapper.insert(user);
        return user;
    }

    @Override
    public String login(String username, String password) {
        User user = userMapper.selectByUsername(username);
        if (user == null || !user.getPassword().equals(password)) {
            throw new RuntimeException("Invalid username or password");
        }
        return JwtUtil.generateToken(user.getId(), user.getUsername());
    }

    @Override
    public User getUserById(Long id) {
        return userMapper.selectById(id);
    }
}