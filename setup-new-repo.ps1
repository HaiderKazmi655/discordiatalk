# Setup New GitHub Repository Script
# This script helps you create a fresh repository with correct structure

Write-Host "=== Setting Up New GitHub Repository ===" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "package.json")) {
    Write-Host "ERROR: package.json not found!" -ForegroundColor Red
    Write-Host "Please run this script from the Dosco-main project folder." -ForegroundColor Yellow
    exit 1
}

Write-Host "✓ Found package.json - we're in the right directory" -ForegroundColor Green
Write-Host ""

# Step 1: Remove old git if exists
if (Test-Path ".git") {
    Write-Host "Removing old .git folder..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force .git
    Write-Host "✓ Old git removed" -ForegroundColor Green
}

# Step 2: Initialize new git repository
Write-Host ""
Write-Host "Initializing new Git repository..." -ForegroundColor Yellow
git init
git branch -M main

# Step 3: Configure Git
Write-Host ""
Write-Host "Configuring Git..." -ForegroundColor Yellow
git config user.name "HaiderKazmi655"
git config user.email "HaiderKazmi655@users.noreply.github.com"
Write-Host "✓ Git configured" -ForegroundColor Green

# Step 4: Add all files
Write-Host ""
Write-Host "Adding all files..." -ForegroundColor Yellow
git add .

# Step 5: Create initial commit
Write-Host ""
Write-Host "Creating initial commit..." -ForegroundColor Yellow
git commit -m "Initial commit: Discord clone with auto-friend feature"
Write-Host "✓ Commit created" -ForegroundColor Green

# Step 6: Get repository name
Write-Host ""
Write-Host "=== GitHub Repository Setup ===" -ForegroundColor Cyan
$repoName = Read-Host "Enter your new GitHub repository name (e.g., 'Dosco' or 'dosco-app')"

if ([string]::IsNullOrWhiteSpace($repoName)) {
    $repoName = "Dosco"
    Write-Host "Using default: $repoName" -ForegroundColor Yellow
}

$repoUrl = "https://github.com/HaiderKazmi655/$repoName.git"

Write-Host ""
Write-Host "Repository URL will be: $repoUrl" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to: https://github.com/new" -ForegroundColor White
Write-Host "2. Create a new repository named: $repoName" -ForegroundColor White
Write-Host "3. DO NOT initialize with README, .gitignore, or license" -ForegroundColor White
Write-Host "4. Click 'Create repository'" -ForegroundColor White
Write-Host ""
$ready = Read-Host "Have you created the repository on GitHub? (y/n)"

if ($ready -eq "y" -or $ready -eq "Y") {
    Write-Host ""
    Write-Host "Adding remote..." -ForegroundColor Yellow
    git remote add origin $repoUrl
    
    Write-Host ""
    Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
    Write-Host "You'll need to use a Personal Access Token as password" -ForegroundColor Gray
    Write-Host ""
    
    # Try to push
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "✓✓✓ SUCCESS! Repository created and pushed! ✓✓✓" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your repository: $repoUrl" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Next: Deploy to Vercel using this new repository" -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "Push failed. You may need to use token in URL:" -ForegroundColor Yellow
        Write-Host "  git remote set-url origin https://HaiderKazmi655:YOUR_TOKEN@github.com/HaiderKazmi655/$repoName.git" -ForegroundColor White
        Write-Host "  git push -u origin main" -ForegroundColor White
    }
} else {
    Write-Host ""
    Write-Host "After creating the repository, run:" -ForegroundColor Yellow
    Write-Host "  git remote add origin $repoUrl" -ForegroundColor White
    Write-Host "  git push -u origin main" -ForegroundColor White
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green

