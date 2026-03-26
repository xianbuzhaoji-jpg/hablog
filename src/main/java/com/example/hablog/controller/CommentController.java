package com.example.hablog.controller;

import com.example.hablog.common.Result;
import com.example.hablog.entity.Comment;
import com.example.hablog.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    @PostMapping
    public Result<Comment> publishComment(@RequestBody Comment comment) {
        Comment result = commentService.publishComment(comment);
        return Result.success(result);
    }

    @GetMapping("/article/{articleId}")
    public Result<String> getComments(@PathVariable Long articleId) {
        return Result.success("Comment list retrieved");
    }
}