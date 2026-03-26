package com.example.hablog.service.impl;

import com.example.hablog.entity.Comment;
import com.example.hablog.mapper.CommentMapper;
import com.example.hablog.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommentServiceImpl implements CommentService {
    
    @Autowired
    private CommentMapper commentMapper;

    @Override
    public Comment publishComment(Comment comment) {
        commentMapper.insert(comment);
        return comment;
    }
}