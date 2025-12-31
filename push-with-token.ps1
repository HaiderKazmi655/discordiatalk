# Push to GitHub with Token Authentication
# This script helps you push when the token popup keeps closing

Write-Host "=== Push to GitHub: Dosco- ===" -ForegroundColor Cyan
Write-Host ""

# Clear any cached credentials first
Write-Host "Clearing cached credentials..." -ForegroundColor Yellow
git credential-manager erase https://github.com 2>$null
git credential reject https://github.com/HaiderKazmi655 2>$null

Write-Host "✓ Credentials cleared" -ForegroundColor Green
Write-Host ""

# Get token from user
Write-Host "Enter your Personal Access Token:" -ForegroundColor Yellow
Write-Host "(Token will be used temporarily and removed after push)" -ForegroundColor Gray
$token = Read-Host "Token" -AsSecureString
$tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

if ([string]::IsNullOrWhiteSpace($tokenPlain)) {
    Write-Host "Token cannot be empty!" -ForegroundColor Red
    exit 1
}

# Set remote with token
$urlWithToken = "https://HaiderKazmi655:$tokenPlain@github.com/HaiderKazmi655/Dosco-.git"
Write-Host ""
Write-Host "Setting up authentication..." -ForegroundColor Yellow
git remote set-url origin $urlWithToken

# Test connection
Write-Host "Testing connection..." -ForegroundColor Yellow
$testResult = git ls-remote origin 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Connection failed!" -ForegroundColor Red
    Write-Host $testResult -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible issues:" -ForegroundColor Yellow
    Write-Host "  - Token is invalid or expired" -ForegroundColor Gray
    Write-Host "  - Token doesn't have 'repo' permissions" -ForegroundColor Gray
    Write-Host "  - Repository doesn't exist or you don't have access" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Get a new token: https://github.com/settings/tokens" -ForegroundColor Cyan
    # Restore original URL
    git remote set-url origin https://github.com/HaiderKazmi655/Dosco-.git
    exit 1
}

Write-Host "✓ Connection successful!" -ForegroundColor Green
Write-Host ""

# Push
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓✓✓ SUCCESS! Code pushed to GitHub! ✓✓✓" -ForegroundColor Green
    Write-Host ""
    Write-Host "Removing token from URL for security..." -ForegroundColor Yellow
    git remote set-url origin https://github.com/HaiderKazmi655/Dosco-.git
    Write-Host "✓ Token removed. Your repository is secure." -ForegroundColor Green
    Write-Host ""
    Write-Host "View your code: https://github.com/HaiderKazmi655/Dosco-" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "✗ Push failed!" -ForegroundColor Red
    Write-Host "Check the error message above." -ForegroundColor Yellow
    # Restore original URL
    git remote set-url origin https://github.com/HaiderKazmi655/Dosco-.git
}

