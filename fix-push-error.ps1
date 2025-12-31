# Fix Push Error - Remote Already Exists
Write-Host "=== Fixing Push Error ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "The repository 'Dosco' already exists on GitHub with content." -ForegroundColor Yellow
Write-Host ""
Write-Host "Options:" -ForegroundColor Cyan
Write-Host "1. Force push (overwrites remote - use if repo is empty/unimportant)" -ForegroundColor White
Write-Host "2. Use a different repository name" -ForegroundColor White
Write-Host "3. Delete the remote repository and create fresh" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Choose option (1/2/3)"

if ($choice -eq "1") {
    Write-Host ""
    Write-Host "⚠️  WARNING: This will overwrite everything in the remote repository!" -ForegroundColor Red
    $confirm = Read-Host "Are you sure? (yes/no)"
    
    if ($confirm -eq "yes") {
        Write-Host ""
        Write-Host "Removing existing remote..." -ForegroundColor Yellow
        git remote remove origin
        
        Write-Host "Adding remote again..." -ForegroundColor Yellow
        git remote add origin https://github.com/HaiderKazmi655/Dosco.git
        
        Write-Host "Force pushing..." -ForegroundColor Yellow
        git push -u origin main --force
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✓✓✓ Success! Repository updated!" -ForegroundColor Green
        } else {
            Write-Host ""
            Write-Host "Push failed. You may need to use a token:" -ForegroundColor Yellow
            Write-Host "  git remote set-url origin https://HaiderKazmi655:YOUR_TOKEN@github.com/HaiderKazmi655/Dosco.git" -ForegroundColor White
            Write-Host "  git push -u origin main --force" -ForegroundColor White
        }
    } else {
        Write-Host "Cancelled." -ForegroundColor Yellow
    }
} elseif ($choice -eq "2") {
    Write-Host ""
    $newName = Read-Host "Enter new repository name"
    
    if ([string]::IsNullOrWhiteSpace($newName)) {
        Write-Host "Invalid name!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Write-Host "Removing old remote..." -ForegroundColor Yellow
    git remote remove origin
    
    Write-Host "Adding new remote..." -ForegroundColor Yellow
    git remote add origin "https://github.com/HaiderKazmi655/$newName.git"
    
    Write-Host ""
    Write-Host "Create the repository on GitHub first:" -ForegroundColor Yellow
    Write-Host "  https://github.com/new" -ForegroundColor White
    Write-Host "  Name: $newName" -ForegroundColor White
    Write-Host "  Don't initialize with anything" -ForegroundColor White
    Write-Host ""
    $ready = Read-Host "Ready to push? (y/n)"
    
    if ($ready -eq "y" -or $ready -eq "Y") {
        git push -u origin main
    }
} elseif ($choice -eq "3") {
    Write-Host ""
    Write-Host "To delete the repository:" -ForegroundColor Yellow
    Write-Host "1. Go to: https://github.com/HaiderKazmi655/Dosco/settings" -ForegroundColor White
    Write-Host "2. Scroll to 'Danger Zone'" -ForegroundColor White
    Write-Host "3. Click 'Delete this repository'" -ForegroundColor White
    Write-Host "4. Type the repository name to confirm" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this script again with option 1" -ForegroundColor Cyan
} else {
    Write-Host "Invalid choice!" -ForegroundColor Red
}

