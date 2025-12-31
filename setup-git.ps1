# Git Setup Script for Dosco Project
# Run this script to configure Git and push to GitHub

Write-Host "=== Git Configuration Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check if Git is installed
$gitVersion = git --version
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Git is not installed or not in PATH" -ForegroundColor Red
    exit 1
}
Write-Host "Git is installed: $gitVersion" -ForegroundColor Green
Write-Host ""

# Get user information
Write-Host "Please provide the following information:" -ForegroundColor Yellow
$gitUserName = Read-Host "Enter your Git user name (e.g., John Doe)"
$gitUserEmail = Read-Host "Enter your Git email (e.g., john@example.com)"

# Configure Git
Write-Host ""
Write-Host "Configuring Git..." -ForegroundColor Cyan
git config user.name "$gitUserName"
git config user.email "$gitUserEmail"

Write-Host "Git configured successfully!" -ForegroundColor Green
Write-Host "  Name: $gitUserName" -ForegroundColor Gray
Write-Host "  Email: $gitUserEmail" -ForegroundColor Gray
Write-Host ""

# Check if there are changes to commit
$status = git status --short
if ($status) {
    Write-Host "Creating initial commit..." -ForegroundColor Cyan
    git commit -m "Initial commit: Discord clone with auto-friend feature"
    Write-Host "Commit created successfully!" -ForegroundColor Green
} else {
    Write-Host "No changes to commit." -ForegroundColor Yellow
}
Write-Host ""

# Ask about GitHub repository
Write-Host "=== GitHub Repository Setup ===" -ForegroundColor Cyan
$hasRepo = Read-Host "Do you already have a GitHub repository? (y/n)"
if ($hasRepo -eq "y" -or $hasRepo -eq "Y") {
    $repoUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/repo.git)"
    
    Write-Host ""
    Write-Host "Adding remote repository..." -ForegroundColor Cyan
    git remote add origin $repoUrl
    
    Write-Host "Remote added successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To push your code, run:" -ForegroundColor Yellow
    Write-Host "  git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "Note: You may need to authenticate with GitHub." -ForegroundColor Yellow
    Write-Host "If you get authentication errors, you may need to:" -ForegroundColor Yellow
    Write-Host "  1. Create a Personal Access Token (PAT) on GitHub" -ForegroundColor Gray
    Write-Host "  2. Use it as your password when pushing" -ForegroundColor Gray
    Write-Host "  3. Or set up SSH keys for authentication" -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "To create a new GitHub repository:" -ForegroundColor Yellow
    Write-Host "  1. Go to https://github.com/new" -ForegroundColor White
    Write-Host "  2. Create a new repository (don't initialize with README)" -ForegroundColor White
    Write-Host "  3. Copy the repository URL" -ForegroundColor White
    Write-Host "  4. Run: git remote add origin <your-repo-url>" -ForegroundColor White
    Write-Host "  5. Run: git push -u origin main" -ForegroundColor White
}
Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green

