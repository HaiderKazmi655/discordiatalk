# Fix GitHub Authentication Issues
# This script helps resolve token authentication problems

Write-Host "=== GitHub Authentication Fix ===" -ForegroundColor Cyan
Write-Host ""

# Step 1: Clear cached credentials
Write-Host "Step 1: Clearing cached Git credentials..." -ForegroundColor Yellow
git credential-manager erase https://github.com 2>$null
git credential reject https://github.com/HaiderKazmi655 2>$null

# Clear Windows Credential Manager entries
Write-Host "Clearing Windows Credential Manager entries..." -ForegroundColor Yellow
$gitCredentials = cmdkey /list 2>$null | Select-String "git"
if ($gitCredentials) {
    Write-Host "Found Git credentials in Windows Credential Manager" -ForegroundColor Yellow
    Write-Host "You may need to manually delete them:" -ForegroundColor Yellow
    Write-Host "  1. Open Control Panel > Credential Manager" -ForegroundColor Gray
    Write-Host "  2. Go to Windows Credentials" -ForegroundColor Gray
    Write-Host "  3. Find and delete any 'git:https://github.com' entries" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Step 2: Verify your repository name" -ForegroundColor Yellow
$currentRemote = git remote get-url origin
Write-Host "Current remote: $currentRemote" -ForegroundColor Cyan

$repoName = Read-Host "Enter the correct repository name (current shows 'Dosco-', is this correct?)"
if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "Dosco"
}

# Fix remote URL if needed
$correctUrl = "https://github.com/HaiderKazmi655/$repoName.git"
if ($currentRemote -ne $correctUrl) {
    Write-Host ""
    Write-Host "Updating remote URL..." -ForegroundColor Yellow
    git remote set-url origin $correctUrl
    Write-Host "Remote updated to: $correctUrl" -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 3: Test connection" -ForegroundColor Yellow
Write-Host "Now try pushing again:" -ForegroundColor Cyan
Write-Host "  git push -u origin main" -ForegroundColor White
Write-Host ""
Write-Host "When prompted:" -ForegroundColor Yellow
Write-Host "  Username: HaiderKazmi655" -ForegroundColor White
Write-Host "  Password: [Paste your Personal Access Token]" -ForegroundColor White
Write-Host ""
Write-Host "If the window closes, try this alternative method:" -ForegroundColor Yellow
Write-Host "  git push -u origin main --verbose" -ForegroundColor White
Write-Host ""

# Alternative: Use token in URL (temporary, less secure)
Write-Host "Alternative: Use token directly in URL (one-time)" -ForegroundColor Yellow
$useTokenInUrl = Read-Host "Do you want to set up token in URL? (y/n) - NOT RECOMMENDED but works"
if ($useTokenInUrl -eq "y" -or $useTokenInUrl -eq "Y") {
    $token = Read-Host "Enter your Personal Access Token" -AsSecureString
    $tokenPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))
    $urlWithToken = "https://HaiderKazmi655:$tokenPlain@github.com/HaiderKazmi655/$repoName.git"
    git remote set-url origin $urlWithToken
    Write-Host "Remote updated with token. You can now push without entering credentials." -ForegroundColor Green
    Write-Host "WARNING: Token is stored in Git config. Consider removing it after push." -ForegroundColor Red
}

