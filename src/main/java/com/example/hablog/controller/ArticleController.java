package com.example.hablog.controller;

import com.example.hablog.common.Result;
import com.example.hablog.entity.Article;
import com.example.hablog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/article")
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    @PostMapping
    public Result<Article> createArticle(@RequestBody Article article) {
        Article result = articleService.createArticle(article);
        return Result.success(result);
    }

    @GetMapping("/{id}")
    public Result<Article> getArticle(@PathVariable Long id) {
        Article article = articleService.getArticleById(id);
        return Result.success(article);
    }
}