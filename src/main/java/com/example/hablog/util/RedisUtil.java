package com.example.hablog.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

@Component
public class RedisUtil {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public Object get(String key) {
        return redisTemplate.opsForValue().get(key);
    }
    
    public void set(String key, Object value) {
        redisTemplate.opsForValue().set(key, value);
    }
    
    public Boolean delete(String key) {
        return redisTemplate.delete(key);
    }
    
    public Long increment(String key) {
        return redisTemplate.opsForValue().increment(key);
    }
}