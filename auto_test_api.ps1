# HaBlog API 自动测试脚本
Write-Host "🚀 开始自动测试 HaBlog API..." -ForegroundColor Green
Write-Host "=" * 50

$baseUrl = "http://localhost:8082/api"

# 测试函数
function Test-Api {
    param($url, $method = "GET", $body = $null, $description)

    Write-Host "📋 测试: $description" -ForegroundColor Yellow
    Write-Host "   URL: $url"
    Write-Host "   Method: $method"

    try {
        $params = @{
            Uri = $url
            Method = $method
            ErrorAction = "Stop"
        }

        if ($body) {
            $params.Body = $body
            $params.ContentType = "application/json"
        }

        $response = Invoke-WebRequest @params
        Write-Host "   ✅ 状态码: $($response.StatusCode)" -ForegroundColor Green

        if ($response.Content) {
            $content = $response.Content | ConvertFrom-Json
            Write-Host "   📄 响应: $($content | ConvertTo-Json -Compress)" -ForegroundColor Cyan
        }

        return $true
    }
    catch {
        Write-Host "   ❌ 错误: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    Write-Host ""
}

# 1. 测试用户注册
Write-Host "👤 1. 测试用户注册" -ForegroundColor Magenta
$registerSuccess = Test-Api -url "$baseUrl/user/register?username=testuser&password=123456&email=test@example.com" -method "POST" -description "用户注册"

# 2. 测试用户登录
Write-Host "🔐 2. 测试用户登录" -ForegroundColor Magenta
$loginSuccess = Test-Api -url "$baseUrl/user/register?username=testuser&password=123456" -method "POST" -description "用户登录"

# 3. 测试创建文章
Write-Host "📝 3. 测试创建文章" -ForegroundColor Magenta
$articleBody = @{
    title = "测试文章"
    content = "这是自动测试创建的文章内容"
    categoryId = 1
    userId = 1
} | ConvertTo-Json

$articleSuccess = Test-Api -url "$baseUrl/article" -method "POST" -body $articleBody -description "创建文章"

# 4. 测试获取文章
Write-Host "📖 4. 测试获取文章" -ForegroundColor Magenta
$articleGetSuccess = Test-Api -url "$baseUrl/article/1" -method "GET" -description "获取文章详情"

# 5. 测试发布评论
Write-Host "💬 5. 测试发布评论" -ForegroundColor Magenta
$commentBody = @{
    content = "这是一条自动测试评论"
    articleId = 1
    userId = 1
} | ConvertTo-Json

$commentSuccess = Test-Api -url "$baseUrl/comment" -method "POST" -body $commentBody -description "发布评论"

# 6. 测试获取评论
Write-Host "📋 6. 测试获取评论" -ForegroundColor Magenta
$commentGetSuccess = Test-Api -url "$baseUrl/comment/article/1" -method "GET" -description "获取文章评论"

# 统计结果
Write-Host "`n" + "=" * 50 -ForegroundColor Cyan
Write-Host "📊 测试结果统计:" -ForegroundColor Cyan
$tests = @(
    @{Name="用户注册"; Success=$registerSuccess},
    @{Name="用户登录"; Success=$loginSuccess},
    @{Name="创建文章"; Success=$articleSuccess},
    @{Name="获取文章"; Success=$articleGetSuccess},
    @{Name="发布评论"; Success=$commentSuccess},
    @{Name="获取评论"; Success=$commentGetSuccess}
)

$passed = 0
$failed = 0

foreach ($test in $tests) {
    if ($test.Success) {
        Write-Host "   ✅ $($test.Name): 通过" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "   ❌ $($test.Name): 失败" -ForegroundColor Red
        $failed++
    }
}

Write-Host "`n🎯 总计: $passed 通过, $failed 失败" -ForegroundColor $(if ($failed -eq 0) { "Green" } else { "Red" })

if ($failed -eq 0) {
    Write-Host "`n🎉 所有测试通过！API 运行正常。" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  部分测试失败，请检查应用配置。" -ForegroundColor Yellow
}

Write-Host "`n🔗 API 文档地址: http://localhost:8081/api/swagger-ui.html" -ForegroundColor Blue
Write-Host "🔗 Knife4j 文档: http://localhost:8081/api/doc.html" -ForegroundColor Blue