# Add GitHub Remote Script for HaiderKazmi655
# This script helps you connect your local repository to GitHub

Write-Host "=== GitHub Remote Setup ===" -ForegroundColor Cyan
Write-Host ""

$repoName = Read-Host "Enter your GitHub repository name (e.g., 'Dosco' or 'Dosco-main')"

if ([string]::IsNullOrWhiteSpace($repoName)) {
    Write-Host "Repository name cannot be empty!" -ForegroundColor Red
    exit 1
}

$remoteUrl = "https://github.com/HaiderKazmi655/$repoName.git"

Write-Host ""
Write-Host "Adding remote: $remoteUrl" -ForegroundColor Yellow

# Check if remote already exists
$existingRemote = git remote get-url origin 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote 'origin' already exists: $existingRemote" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to replace it? (y/n)"
    if ($overwrite -eq "y" -or $overwrite -eq "Y") {
        git remote remove origin
        Write-Host "Old remote removed." -ForegroundColor Green
    } else {
        Write-Host "Keeping existing remote. Exiting." -ForegroundColor Yellow
        exit 0
    }
}

git remote add origin $remoteUrl

if ($LASTEXITCODE -eq 0) {
    Write-Host "Remote added successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next step: Push your code" -ForegroundColor Cyan
    Write-Host "Run: git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "Note: You'll need a Personal Access Token for authentication." -ForegroundColor Yellow
    Write-Host "Get one at: https://github.com/settings/tokens" -ForegroundColor Gray
} else {
    Write-Host "Failed to add remote. Please check the repository name." -ForegroundColor Red
}

