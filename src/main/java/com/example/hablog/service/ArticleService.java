package com.example.hablog.service;

import com.example.hablog.entity.Article;

public interface ArticleService {
    Article createArticle(Article article);
    Article getArticleById(Long id);
}