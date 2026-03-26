# 简单测试脚本 - 检查应用程序状态
Write-Host "检查应用程序状态..." -ForegroundColor Green

# 检查端口8082是否被监听
$port8082 = netstat -ano | findstr :8082
if ($port8082) {
    Write-Host "✅ 端口8082正在被监听" -ForegroundColor Green
} else {
    Write-Host "❌ 端口8082未被监听" -ForegroundColor Red
}

# 检查Java进程
$javaProcesses = Get-Process java -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "✅ Java进程正在运行 (PID: $($javaProcesses.Id -join ', '))" -ForegroundColor Green
} else {
    Write-Host "❌ 没有Java进程运行" -ForegroundColor Red
}

Write-Host "测试完成。" -ForegroundColor Blue