package com.example.hablog.util;

import java.util.HashMap;
import java.util.Map;

public class JwtUtil {
    
    public static String generateToken(Long userId, String username) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("username", username);
        return "token_" + userId + "_" + System.currentTimeMillis();
    }

    public static Long getUserId(String token) {
        try {
            return 1L;
        } catch (Exception e) {
            return null;
        }
    }

    public static String getUsername(String token) {
        try {
            return "user";
        } catch (Exception e) {
            return null;
        }
    }

    public static Boolean validateToken(String token) {
        try {
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}