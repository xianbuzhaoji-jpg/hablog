package com.example.hablog.service;

import com.example.hablog.entity.Category;

public interface CategoryService {
    Category createCategory(Category category);
    Category getCategoryById(Long id);
}