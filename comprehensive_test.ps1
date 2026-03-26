# HaBlog API 完整测试脚本 - 故障排除版本
Write-Host "🔧 HaBlog API 完整测试脚本" -ForegroundColor Cyan
Write-Host "=" * 60

# 步骤1: 检查应用程序状态
Write-Host "`n📊 步骤1: 检查应用程序状态" -ForegroundColor Yellow
Write-Host "-" * 40

# 检查Java进程
$javaProcesses = Get-Process java -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "✅ Java进程正在运行:" -ForegroundColor Green
    foreach ($proc in $javaProcesses) {
        Write-Host "   PID: $($proc.Id), 启动时间: $($proc.StartTime)" -ForegroundColor Gray
    }
} else {
    Write-Host "❌ 没有Java进程运行" -ForegroundColor Red
    Write-Host "请先运行: mvn spring-boot:run" -ForegroundColor Yellow
    exit 1
}

# 检查端口
$port8082 = netstat -ano | findstr :8082
if ($port8082) {
    Write-Host "✅ 端口8082正在被监听" -ForegroundColor Green
} else {
    Write-Host "❌ 端口8082未被监听" -ForegroundColor Red
    Write-Host "应用程序可能没有正确启动" -ForegroundColor Yellow
}

# 步骤2: 测试基本连接
Write-Host "`n🌐 步骤2: 测试基本连接" -ForegroundColor Yellow
Write-Host "-" * 40

$baseUrl = "http://localhost:8082/api"
Write-Host "测试基础URL: $baseUrl" -ForegroundColor Gray

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/" -ErrorAction Stop -TimeoutSec 10
    Write-Host "✅ 基础连接成功 (状态码: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ 基础连接失败: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Message -match "404") {
        Write-Host "   提示: 应用程序可能启动了但API路径不正确" -ForegroundColor Yellow
    } elseif ($_.Exception.Message -match "connection") {
        Write-Host "   提示: 应用程序可能没有在端口8082上运行" -ForegroundColor Yellow
    }
}

# 步骤3: 测试API端点
Write-Host "`n🔗 步骤3: 测试API端点" -ForegroundColor Yellow
Write-Host "-" * 40

$testCases = @(
    @{
        url = "$baseUrl/user/register?username=testuser&password=123456&email=test@example.com"
        method = "POST"
        description = "用户注册"
    },
    @{
        url = "$baseUrl/user/login?username=testuser&password=123456"
        method = "POST"
        description = "用户登录"
    },
    @{
        url = "$baseUrl/article"
        method = "POST"
        body = @{
            title = "测试文章"
            content = "这是测试内容"
            categoryId = 1
        } | ConvertTo-Json
        description = "创建文章"
    },
    @{
        url = "$baseUrl/article/1"
        method = "GET"
        description = "获取文章"
    },
    @{
        url = "$baseUrl/category"
        method = "GET"
        description = "获取分类列表"
    }
)

$results = @()
foreach ($test in $testCases) {
    Write-Host "`n测试: $($test.description)" -ForegroundColor Cyan
    Write-Host "URL: $($test.url)"
    Write-Host "Method: $($test.method)"

    try {
        $params = @{
            Uri = $test.url
            Method = $test.method
            ErrorAction = "Stop"
            TimeoutSec = 10
        }

        if ($test.body) {
            $params.ContentType = "application/json"
            $params.Body = $test.body
        }

        $response = Invoke-WebRequest @params
        Write-Host "✅ 成功 (状态码: $($response.StatusCode))" -ForegroundColor Green

        if ($response.Content) {
            try {
                $jsonResponse = $response.Content | ConvertFrom-Json
                Write-Host "响应: $(if ($jsonResponse.code -eq 200) { '成功' } else { '业务错误' })" -ForegroundColor Gray
            } catch {
                Write-Host "响应内容: $($response.Content.Substring(0, [Math]::Min(100, $response.Content.Length)))..." -ForegroundColor Gray
            }
        }

        $results += @{
            Test = $test.description
            Status = "成功"
            StatusCode = $response.StatusCode
            Error = $null
        }

    } catch {
        $statusCode = if ($_.Exception.Response) { $_.Exception.Response.StatusCode } else { "未知" }
        Write-Host "❌ 失败 (状态码: $statusCode)" -ForegroundColor Red
        Write-Host "错误: $($_.Exception.Message)" -ForegroundColor Red

        $results += @{
            Test = $test.description
            Status = "失败"
            StatusCode = $statusCode
            Error = $_.Exception.Message
        }
    }
}

# 步骤4: 显示测试结果摘要
Write-Host "`n📈 步骤4: 测试结果摘要" -ForegroundColor Yellow
Write-Host "-" * 40

$successCount = ($results | Where-Object { $_.Status -eq "成功" }).Count
$totalCount = $results.Count

Write-Host "总测试数: $totalCount" -ForegroundColor White
Write-Host "成功数: $successCount" -ForegroundColor Green
Write-Host "失败数: $($totalCount - $successCount)" -ForegroundColor Red

if ($successCount -eq $totalCount) {
    Write-Host "`n🎉 所有测试都通过了！" -ForegroundColor Green
} else {
    Write-Host "`n⚠️  部分测试失败，需要进一步检查" -ForegroundColor Yellow

    Write-Host "`n失败的测试:" -ForegroundColor Red
    $results | Where-Object { $_.Status -eq "失败" } | ForEach-Object {
        Write-Host "  - $($_.Test): $($_.Error)" -ForegroundColor Red
    }
}

# 步骤5: 故障排除建议
Write-Host "`n🔧 步骤5: 故障排除建议" -ForegroundColor Yellow
Write-Host "-" * 40

if ($successCount -lt $totalCount) {
    Write-Host "常见问题和解决方案:" -ForegroundColor Cyan
    Write-Host "1. 数据库连接问题:" -ForegroundColor White
    Write-Host "   - 确保MySQL服务正在运行" -ForegroundColor Gray
    Write-Host "   - 检查application.yml中的数据库配置" -ForegroundColor Gray
    Write-Host "   - 创建hablog数据库: CREATE DATABASE hablog;" -ForegroundColor Gray

    Write-Host "`n2. API路径问题:" -ForegroundColor White
    Write-Host "   - 确保context-path设置为/api" -ForegroundColor Gray
    Write-Host "   - 检查Controller上的@RequestMapping注解" -ForegroundColor Gray

    Write-Host "`n3. 端口问题:" -ForegroundColor White
    Write-Host "   - 确保应用程序在端口8082上运行" -ForegroundColor Gray
    Write-Host "   - 检查是否有其他进程占用端口" -ForegroundColor Gray

    Write-Host "`n4. 依赖问题:" -ForegroundColor White
    Write-Host "   - 运行 mvn clean compile 重新编译" -ForegroundColor Gray
    Write-Host "   - 检查pom.xml中的依赖版本" -ForegroundColor Gray
}

Write-Host "`n测试完成！" -ForegroundColor Green
Write-Host "如有问题，请检查上述故障排除建议或查看应用程序日志。" -ForegroundColor Blue