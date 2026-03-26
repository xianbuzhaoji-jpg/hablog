package com.example.hablog.service.impl;

import com.example.hablog.entity.Category;
import com.example.hablog.mapper.CategoryMapper;
import com.example.hablog.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CategoryServiceImpl implements CategoryService {
    
    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public Category createCategory(Category category) {
        categoryMapper.insert(category);
        return category;
    }

    @Override
    public Category getCategoryById(Long id) {
        return categoryMapper.selectById(id);
    }
}