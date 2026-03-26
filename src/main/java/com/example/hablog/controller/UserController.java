package com.example.hablog.controller;

import com.example.hablog.common.Result;
import com.example.hablog.entity.User;
import com.example.hablog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
public class UserController {
    
    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public Result<User> register(@RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam String email) {
        User user = userService.register(username, password, email);
        return Result.success(user);
    }

    @PostMapping("/login")
    public Result<String> login(@RequestParam String username,
                               @RequestParam String password) {
        String token = userService.login(username, password);
        return Result.success(token);
    }

    @GetMapping("/profile")
    public Result<User> profile() {
        User user = userService.getUserById(1L);
        return Result.success(user);
    }
}