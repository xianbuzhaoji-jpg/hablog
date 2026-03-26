package com.example.hablog.service.impl;

import com.example.hablog.entity.Article;
import com.example.hablog.mapper.ArticleMapper;
import com.example.hablog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ArticleServiceImpl implements ArticleService {
    
    @Autowired
    private ArticleMapper articleMapper;

    @Override
    public Article createArticle(Article article) {
        articleMapper.insert(article);
        return article;
    }

    @Override
    public Article getArticleById(Long id) {
        return articleMapper.selectById(id);
    }
}