# Complete Fix Script for GitHub Push Issues
Write-Host "=== GitHub Push Fix Script ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Ask for correct repository name
Write-Host "Your current repository URL has a trailing dash: Dosco-" -ForegroundColor Yellow
Write-Host "This is likely incorrect." -ForegroundColor Yellow
Write-Host ""
Write-Host "Please check your GitHub repositories:" -ForegroundColor Cyan
Write-Host "  https://github.com/HaiderKazmi655?tab=repositories" -ForegroundColor White
Write-Host ""

$repoName = Read-Host "Enter the EXACT repository name (case-sensitive, e.g., 'Dosco' or 'Dosco-main')"

if ([string]::IsNullOrWhiteSpace($repoName)) {
    Write-Host "Using default: Dosco" -ForegroundColor Yellow
    $repoName = "Dosco"
}

$correctUrl = "https://github.com/HaiderKazmi655/$repoName.git"

Write-Host ""
Write-Host "Updating remote URL to: $correctUrl" -ForegroundColor Yellow
git remote set-url origin $correctUrl

# Step 2: Clear credentials
Write-Host ""
Write-Host "Clearing cached credentials..." -ForegroundColor Yellow
git credential-manager erase https://github.com 2>$null
git credential reject https://github.com/HaiderKazmi655 2>$null

# Step 3: Test connection
Write-Host ""
Write-Host "Testing connection..." -ForegroundColor Yellow
$testResult = git ls-remote origin 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Connection successful! Repository exists." -ForegroundColor Green
    Write-Host ""
    Write-Host "Now you can push. Choose an option:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Option 1: Push with token prompt (recommended)" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
    Write-Host "  When prompted, use your Personal Access Token as password" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Option 2: Push with token in URL (if popup keeps closing)" -ForegroundColor Yellow
    $useToken = Read-Host "Do you want to use token in URL? (y/n)"
    if ($useToken -eq "y" -or $useToken -eq "Y") {
        $token = Read-Host "Enter your Personal Access Token" -AsSecureString
        $tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
        $urlWithToken = "https://HaiderKazmi655:$tokenPlain@github.com/HaiderKazmi655/$repoName.git"
        git remote set-url origin $urlWithToken
        Write-Host ""
        Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
        git push -u origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✓ Successfully pushed to GitHub!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Removing token from URL for security..." -ForegroundColor Yellow
            git remote set-url origin $correctUrl
            Write-Host "✓ Token removed. Your code is now on GitHub!" -ForegroundColor Green
        }
    }
} else {
    Write-Host "✗ Connection failed!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Possible issues:" -ForegroundColor Yellow
    Write-Host "  1. Repository '$repoName' doesn't exist on GitHub" -ForegroundColor Gray
    Write-Host "  2. Repository name is incorrect (check case sensitivity)" -ForegroundColor Gray
    Write-Host "  3. Repository is private and token doesn't have access" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Solutions:" -ForegroundColor Cyan
    Write-Host "  1. Create the repository: https://github.com/new" -ForegroundColor White
    Write-Host "     Name: $repoName" -ForegroundColor White
    Write-Host "     Don't initialize with README" -ForegroundColor White
    Write-Host "  2. Or check your existing repositories:" -ForegroundColor White
    Write-Host "     https://github.com/HaiderKazmi655?tab=repositories" -ForegroundColor White
}

